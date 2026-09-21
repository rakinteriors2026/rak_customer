import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:rak_customer/features/cart/data/datasources/checkout_local_datasource.dart';
import 'package:rak_customer/features/cart/data/repositories/checkout_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late CartLocalDatasource cart;
  late CheckoutRepositoryImpl checkout;

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    cart = CartLocalDatasource(db);
    checkout = CheckoutRepositoryImpl(
      CheckoutLocalDatasource(
        db: db,
        clock: Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30)),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('does not confirm an order without an address', () async {
    await cart.addProduct(
      productId: 'prod_oak_table',
      accountId: SeedData.buyerAccountId,
    );
    final result = await checkout.placeOrder(
      accountId: SeedData.buyerAccountId,
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(result.valueOrNull, isNull);
  });

  test('does not confirm an order when the cart is empty', () async {
    final saved = await checkout.saveAddress(
      accountId: SeedData.buyerAccountId,
      fullName: 'Rahul Nair',
      mobile: '+919876540002',
      line: '12 Palm Street',
      postcode: '682019',
    );
    expect(saved.isSuccess, isTrue);

    final result = await checkout.placeOrder(
      accountId: SeedData.buyerAccountId,
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
  });

  test('saves the address and confirms only after placing the order', () async {
    await cart.addProduct(
      productId: 'prod_oak_table',
      accountId: SeedData.buyerAccountId,
    );
    await checkout.saveAddress(
      accountId: SeedData.buyerAccountId,
      fullName: 'Rahul Nair',
      mobile: '+919876540002',
      line: '12 Palm Street',
      postcode: '682019',
    );

    final placed = await checkout.placeOrder(
      accountId: SeedData.buyerAccountId,
    );
    expect(placed.isSuccess, isTrue);
    expect(placed.valueOrNull?.isConfirmed, isTrue);
    expect(placed.valueOrNull?.address.line, '12 Palm Street');
    expect(placed.valueOrNull?.lines, isNotEmpty);

    final remaining = await cart.getOrCreate(
      accountId: SeedData.buyerAccountId,
    );
    expect(remaining.isEmpty, isTrue);

    final loaded = await checkout.getAddress(
      accountId: SeedData.buyerAccountId,
    );
    expect(loaded.valueOrNull?.fullName, 'Rahul Nair');
  });
}
