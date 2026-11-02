import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';
import 'package:rak_customer/features/cart/domain/usecases/save_delivery_address.dart';

class _MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late _MockCheckoutRepository repository;
  late SaveDeliveryAddress usecase;

  const address = DeliveryAddress(
    fullName: 'Rahul Nair',
    mobile: '+919876540002',
    line: '12 Palm Street',
    postcode: '682019',
  );

  setUp(() {
    repository = _MockCheckoutRepository();
    usecase = SaveDeliveryAddress(repository);
  });

  test('rejects blank fields without calling the repository', () async {
    final result = await usecase(
      accountId: 'acc',
      fullName: 'Omar',
      mobile: '',
      line: '12 Palm Street',
      postcode: '682019',
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(
      () => repository.saveAddress(
        accountId: any(named: 'accountId'),
        fullName: any(named: 'fullName'),
        mobile: any(named: 'mobile'),
        line: any(named: 'line'),
        postcode: any(named: 'postcode'),
      ),
    );
  });

  test('rejects a PIN outside the demo delivery area', () async {
    final result = await usecase(
      accountId: 'acc',
      fullName: 'Rahul Nair',
      mobile: '+919876540002',
      line: '12 Palm Street',
      postcode: '110001',
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(
      () => repository.saveAddress(
        accountId: any(named: 'accountId'),
        fullName: any(named: 'fullName'),
        mobile: any(named: 'mobile'),
        line: any(named: 'line'),
        postcode: any(named: 'postcode'),
      ),
    );
  });

  test('saves a complete address through the repository', () async {
    when(
      () => repository.saveAddress(
        accountId: 'acc',
        fullName: 'Rahul Nair',
        mobile: '+919876540002',
        line: '12 Palm Street',
        postcode: '682019',
      ),
    ).thenAnswer((_) async => const Success(address));

    final result = await usecase(
      accountId: 'acc',
      fullName: 'Rahul Nair',
      mobile: '+919876540002',
      line: '12 Palm Street',
      postcode: '682019',
    );

    expect(result.valueOrNull, address);
  });
}
