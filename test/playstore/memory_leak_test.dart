import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/update_cart_line_quantity.dart';
import 'package:rak_customer/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:rak_customer/features/cart/presentation/cubit/checkout_cubit.dart';

class _MockGetCart extends Mock implements GetCart {}

class _MockUpdateCartLineQuantity extends Mock implements UpdateCartLineQuantity {}

class _MockGetDeliveryAddress extends Mock implements GetDeliveryAddress {}

class _MockShopBranchRepository extends Mock implements ShopBranchRepository {}

void main() {
  const emptyCart = ShoppingCart(
    id: 'cart',
    lines: [],
    totalMinor: 0,
    currency: 'INR',
    version: 1,
  );

  late StreamController<ShopBranch> branches;
  late _MockShopBranchRepository repository;
  late _MockGetCart getCart;

  setUp(() {
    branches = StreamController<ShopBranch>.broadcast();
    repository = _MockShopBranchRepository();
    getCart = _MockGetCart();
    when(() => repository.watchSelected()).thenAnswer((_) => branches.stream);
    when(
      () => getCart(accountId: any(named: 'accountId')),
    ).thenAnswer((_) async => const Success(emptyCart));
  });

  tearDown(() async {
    await branches.close();
  });

  test('CartCubit drops the branch subscription when closed', () async {
    final cubit = CartCubit(
      getCart: getCart,
      updateCartLineQuantity: _MockUpdateCartLineQuantity(),
      shopBranchRepository: repository,
    );

    expect(branches.hasListener, isTrue);
    await cubit.close();
    expect(branches.hasListener, isFalse);
    expect(cubit.isClosed, isTrue);
  });

  test('CheckoutCubit drops the branch subscription when closed', () async {
    final getAddress = _MockGetDeliveryAddress();
    when(
      () => getAddress(accountId: any(named: 'accountId')),
    ).thenAnswer((_) async => const Success<DeliveryAddress?>(null));

    final cubit = CheckoutCubit(
      getCart: getCart,
      getDeliveryAddress: getAddress,
      shopBranchRepository: repository,
      accountId: 'acc',
    );

    expect(branches.hasListener, isTrue);
    await cubit.close();
    expect(branches.hasListener, isFalse);
    expect(cubit.isClosed, isTrue);
  });

  test('closed CartCubit does not emit after a late branch change', () async {
    final cubit = CartCubit(
      getCart: getCart,
      updateCartLineQuantity: _MockUpdateCartLineQuantity(),
      shopBranchRepository: repository,
    );
    await cubit.close();

    Object? emitted;
    final sub = cubit.stream.listen((state) => emitted = state);
    branches.add(ShopBranch.kochi);
    await Future<void>.delayed(Duration.zero);
    expect(emitted, isNull);
    await sub.cancel();
  });
}
