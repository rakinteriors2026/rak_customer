import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';
import 'package:rak_customer/features/cart/domain/usecases/update_cart_line_quantity.dart';

class _MockCartRepository extends Mock implements CartRepository {}

void main() {
  late _MockCartRepository repository;
  late UpdateCartLineQuantity usecase;

  setUp(() {
    repository = _MockCartRepository();
    usecase = UpdateCartLineQuantity(repository);
  });

  test('rejects an empty line id', () async {
    final result = await usecase(lineId: '', quantity: 2);
    expect(result.isFailure, isTrue);
    expect(result.failureOrNull, isA<ValidationFailure>());
  });

  test('updates quantity through the repository', () async {
    const cart = ShoppingCart(
      id: 'cart',
      lines: [],
      totalMinor: 0,
      currency: 'INR',
      version: 1,
    );
    when(
      () => repository.setLineQuantity(
        lineId: 'line-1',
        quantity: 2,
        accountId: 'acc',
      ),
    ).thenAnswer((_) async => const Success(cart));

    final result = await usecase(
      lineId: 'line-1',
      quantity: 2,
      accountId: 'acc',
    );

    expect(result.valueOrNull, cart);
    verify(
      () => repository.setLineQuantity(
        lineId: 'line-1',
        quantity: 2,
        accountId: 'acc',
      ),
    ).called(1);
  });
}
