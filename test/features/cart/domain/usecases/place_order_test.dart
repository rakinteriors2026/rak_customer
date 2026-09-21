import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';
import 'package:rak_customer/features/cart/domain/usecases/place_order.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late _MockCheckoutRepository repository;
  late PlaceOrder usecase;

  final order = ShopOrder(
    id: 'ord_1',
    accountId: 'acc',
    status: 'confirmed',
    address: const DeliveryAddress(
      fullName: 'Rahul Nair',
      mobile: '+919876540002',
      line: '12 Palm Street',
      postcode: '682019',
    ),
    lines: const [],
    totalMinor: 100,
    currency: 'INR',
    createdAt: DateTime.utc(2026, 9, 8),
  );

  setUp(() {
    repository = _MockCheckoutRepository();
    usecase = PlaceOrder(repository);
  });

  test('rejects an empty account id', () async {
    final result = await usecase(accountId: '  ');
    expect(result.failureOrNull, isA<UnauthorizedFailure>());
    verifyNever(
      () => repository.placeOrder(accountId: any(named: 'accountId')),
    );
  });

  test('places an order through the repository', () async {
    when(
      () => repository.placeOrder(accountId: 'acc'),
    ).thenAnswer((_) async => Success(order));

    final result = await usecase(accountId: 'acc');

    expect(result.valueOrNull?.id, 'ord_1');
    expect(result.valueOrNull?.isConfirmed, isTrue);
    verify(() => repository.placeOrder(accountId: 'acc')).called(1);
  });

  test('surfaces a missing address as failure', () async {
    when(() => repository.placeOrder(accountId: 'acc')).thenAnswer(
      (_) async => const Err(
        ValidationFailure('Add a delivery address before placing the order.'),
      ),
    );

    final result = await usecase(accountId: 'acc');
    expect(result.failureOrNull, isA<ValidationFailure>());
  });
}
