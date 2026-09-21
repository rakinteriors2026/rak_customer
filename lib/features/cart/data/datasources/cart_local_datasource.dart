import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:uuid/uuid.dart';

class CartLocalDatasource {
  CartLocalDatasource(this._db, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Uuid _uuid;

  Future<ShoppingCart> getOrCreate({String? accountId}) async {
    final cartRow = await _cartRow(accountId);
    return _toCart(cartRow);
  }

  Future<ShoppingCart> addProduct({
    required String productId,
    String? accountId,
  }) async {
    final product = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(productId))).getSingleOrNull();
    if (product == null) {
      throw const NotFoundFailure('This product is not available.');
    }
    if (product.salesMode == 'quotation_only' || product.priceMinor == null) {
      throw const ValidationFailure('This item is available by quote only.');
    }

    final cart = await _cartRow(accountId);
    final existing =
        await (_db.select(_db.cartItems)..where(
              (t) => t.cartId.equals(cart.id) & t.productId.equals(productId),
            ))
            .getSingleOrNull();

    if (existing == null) {
      await _db
          .into(_db.cartItems)
          .insert(
            CartItemsCompanion.insert(
              id: _uuid.v4(),
              cartId: cart.id,
              productId: product.id,
              nameSnapshot: product.name,
              unitPriceMinor: product.priceMinor!,
              currency: product.currency,
              quantity: 1,
            ),
          );
    } else {
      await (_db.update(_db.cartItems)..where((t) => t.id.equals(existing.id)))
          .write(CartItemsCompanion(quantity: Value(existing.quantity + 1)));
    }

    await _recomputeTotal(cart.id, product.currency);
    return getOrCreate(accountId: accountId);
  }

  Future<ShoppingCart> setLineQuantity({
    required String lineId,
    required int quantity,
    String? accountId,
  }) async {
    final existing = await (_db.select(
      _db.cartItems,
    )..where((t) => t.id.equals(lineId))).getSingleOrNull();
    if (existing == null) {
      throw const NotFoundFailure('This cart item is no longer available.');
    }
    if (quantity <= 0) {
      await (_db.delete(_db.cartItems)..where((t) => t.id.equals(lineId))).go();
    } else {
      await (_db.update(_db.cartItems)..where((t) => t.id.equals(lineId)))
          .write(CartItemsCompanion(quantity: Value(quantity)));
    }
    await _recomputeTotal(existing.cartId, existing.currency);
    return getOrCreate(accountId: accountId);
  }

  Future<CartRow> _cartRow(String? accountId) async {
    if (accountId == null) {
      return (_db.select(
        _db.carts,
      )..where((t) => t.id.equals(SeedData.guestCartId))).getSingle();
    }
    final existing = await (_db.select(
      _db.carts,
    )..where((t) => t.accountId.equals(accountId))).getSingleOrNull();
    if (existing != null) return existing;
    final id = 'cart_$accountId';
    await _db
        .into(_db.carts)
        .insert(
          CartsCompanion.insert(
            id: id,
            accountId: Value(accountId),
            totalMinor: 0,
          ),
        );
    return (_db.select(_db.carts)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> _recomputeTotal(String cartId, String currency) async {
    final lines = await (_db.select(
      _db.cartItems,
    )..where((t) => t.cartId.equals(cartId))).get();
    final total = lines.fold<int>(
      0,
      (sum, line) => sum + line.unitPriceMinor * line.quantity,
    );
    final current = await (_db.select(
      _db.carts,
    )..where((t) => t.id.equals(cartId))).getSingle();
    await (_db.update(_db.carts)..where((t) => t.id.equals(cartId))).write(
      CartsCompanion(
        totalMinor: Value(total),
        currency: Value(currency),
        version: Value(current.version + 1),
      ),
    );
  }

  Future<ShoppingCart> _toCart(CartRow cart) async {
    final lines = await (_db.select(
      _db.cartItems,
    )..where((t) => t.cartId.equals(cart.id))).get();
    final productIds = lines.map((line) => line.productId).toSet();
    final hints = <String, String>{};
    if (productIds.isNotEmpty) {
      final products = await (_db.select(
        _db.products,
      )..where((t) => t.id.isIn(productIds))).get();
      for (final product in products) {
        hints[product.id] = product.imageHint;
      }
    }
    return ShoppingCart(
      id: cart.id,
      totalMinor: cart.totalMinor,
      currency: cart.currency,
      version: cart.version,
      lines: lines
          .map(
            (line) => CartLine(
              id: line.id,
              productId: line.productId,
              name: line.nameSnapshot,
              unitPriceMinor: line.unitPriceMinor,
              currency: line.currency,
              quantity: line.quantity,
              unavailable: line.unavailable,
              repriced: line.repriced,
              imageHint: hints[line.productId] ?? 'placeholder',
            ),
          )
          .toList(),
    );
  }
}
