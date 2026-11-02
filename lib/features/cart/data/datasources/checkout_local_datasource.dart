import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:uuid/uuid.dart';

class CheckoutLocalDatasource {
  CheckoutLocalDatasource({
    required AppDatabase db,
    required Clock clock,
    Uuid? uuid,
  }) : _db = db,
       _clock = clock,
       _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Future<DeliveryAddress?> getAddress(String accountId) async {
    final row = await (_db.select(
      _db.deliveryAddresses,
    )..where((t) => t.accountId.equals(accountId))).getSingleOrNull();
    return row == null ? null : _toAddress(row);
  }

  Future<DeliveryAddress> saveAddress({
    required String accountId,
    required String fullName,
    required String mobile,
    required String line,
    required String postcode,
  }) async {
    final now = _clock.now().toUtc();
    await _db
        .into(_db.deliveryAddresses)
        .insertOnConflictUpdate(
          DeliveryAddressesCompanion.insert(
            accountId: accountId,
            fullName: fullName.trim(),
            mobile: mobile.trim(),
            line: line.trim(),
            postcode: postcode.trim(),
            updatedAt: now,
          ),
        );
    final saved = await getAddress(accountId);
    if (saved == null) {
      throw const UnknownFailure('The address could not be saved.');
    }
    return saved;
  }

  bool _placing = false;

  Future<ShopOrder> placeOrder({required String accountId}) async {
    if (_placing) {
      throw const ValidationFailure(
        'Payment confirmation is already in progress.',
      );
    }
    _placing = true;
    try {
      return await _placeOrder(accountId: accountId);
    } finally {
      _placing = false;
    }
  }

  Future<ShopOrder> _placeOrder({required String accountId}) async {
    final address = await getAddress(accountId);
    if (address == null) {
      throw const ValidationFailure(
        'Add a delivery address before placing the order.',
      );
    }

    final cart = await (_db.select(
      _db.carts,
    )..where((t) => t.accountId.equals(accountId))).getSingleOrNull();
    if (cart == null) {
      throw const ValidationFailure('Your cart is empty.');
    }

    final lines = await (_db.select(
      _db.cartItems,
    )..where((t) => t.cartId.equals(cart.id))).get();
    if (lines.isEmpty) {
      throw const ValidationFailure('Your cart is empty.');
    }
    if (lines.any((line) => line.unavailable)) {
      throw const ValidationFailure(
        'Remove unavailable items before placing the order.',
      );
    }

    final productIds = lines.map((line) => line.productId).toSet();
    final products = await (_db.select(
      _db.products,
    )..where((t) => t.id.isIn(productIds))).get();
    final hints = {
      for (final product in products) product.id: product.imageHint,
    };

    final now = _clock.now().toUtc();
    final orderId = 'ord_${now.microsecondsSinceEpoch}';
    final totalMinor = cart.totalMinor + AppLayout.deliveryMinor;

    await _db.transaction(() async {
      await _db
          .into(_db.shopOrders)
          .insert(
            ShopOrdersCompanion.insert(
              id: orderId,
              accountId: accountId,
              status: 'confirmed',
              fullName: address.fullName,
              mobile: address.mobile,
              addressLine: address.line,
              postcode: address.postcode,
              totalMinor: totalMinor,
              currency: cart.currency,
              createdAt: now,
            ),
          );
      for (final line in lines) {
        await _db
            .into(_db.shopOrderItems)
            .insert(
              ShopOrderItemsCompanion.insert(
                id: _uuid.v4(),
                orderId: orderId,
                productId: line.productId,
                nameSnapshot: line.nameSnapshot,
                imageHint: hints[line.productId] ?? 'placeholder',
                unitPriceMinor: line.unitPriceMinor,
                currency: line.currency,
                quantity: line.quantity,
              ),
            );
      }
      await (_db.delete(
        _db.cartItems,
      )..where((t) => t.cartId.equals(cart.id))).go();
      await (_db.update(_db.carts)..where((t) => t.id.equals(cart.id))).write(
        CartsCompanion(
          totalMinor: const Value(0),
          version: Value(cart.version + 1),
        ),
      );
    });

    return getOrder(accountId: accountId, orderId: orderId);
  }

  Future<ShopOrder> getOrder({
    required String accountId,
    required String orderId,
  }) async {
    final row =
        await (_db.select(_db.shopOrders)..where(
              (t) => t.id.equals(orderId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw const NotFoundFailure('This order is not available.');
    }
    final items = await (_db.select(
      _db.shopOrderItems,
    )..where((t) => t.orderId.equals(row.id))).get();
    return ShopOrder(
      id: row.id,
      accountId: row.accountId,
      status: row.status,
      address: DeliveryAddress(
        fullName: row.fullName,
        mobile: row.mobile,
        line: row.addressLine,
        postcode: row.postcode,
      ),
      lines: [
        for (final item in items)
          ShopOrderLine(
            id: item.id,
            productId: item.productId,
            name: item.nameSnapshot,
            imageHint: item.imageHint,
            unitPriceMinor: item.unitPriceMinor,
            currency: item.currency,
            quantity: item.quantity,
          ),
      ],
      totalMinor: row.totalMinor,
      currency: row.currency,
      createdAt: row.createdAt,
    );
  }

  Future<ShopOrder> updateStatus({
    required String accountId,
    required String orderId,
    required String status,
  }) async {
    if (!ShopOrder.knownStatuses.contains(status)) {
      throw const ValidationFailure('That order status is not available.');
    }
    final row =
        await (_db.select(_db.shopOrders)..where(
              (t) => t.id.equals(orderId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw const NotFoundFailure('This order is not available.');
    }
    await (_db.update(_db.shopOrders)..where((t) => t.id.equals(orderId)))
        .write(ShopOrdersCompanion(status: Value(status)));
    return getOrder(accountId: accountId, orderId: orderId);
  }

  Future<List<ShopOrder>> listOrders(String accountId) async {
    final rows =
        await (_db.select(_db.shopOrders)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    final orders = <ShopOrder>[];
    for (final row in rows) {
      orders.add(await getOrder(accountId: accountId, orderId: row.id));
    }
    return orders;
  }

  DeliveryAddress _toAddress(DeliveryAddressRow row) {
    return DeliveryAddress(
      fullName: row.fullName,
      mobile: row.mobile,
      line: row.line,
      postcode: row.postcode,
    );
  }
}
