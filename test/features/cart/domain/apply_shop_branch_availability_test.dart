import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/apply_shop_branch_availability.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';

class _MockShopBranchRepository extends Mock implements ShopBranchRepository {}

void main() {
  const cart = ShoppingCart(
    id: 'cart',
    lines: [
      CartLine(
        id: 'line_1',
        productId: 'prod_linen_sofa',
        name: 'Linen sofa',
        unitPriceMinor: 100,
        currency: 'INR',
        quantity: 1,
        unavailable: false,
        repriced: false,
      ),
    ],
    totalMinor: 100,
    currency: 'INR',
    version: 1,
  );

  test('marks a line unavailable when the branch does not stock it', () async {
    final repository = _MockShopBranchRepository();
    when(
      () => repository.isProductAvailable(productId: 'prod_linen_sofa'),
    ).thenAnswer((_) async => const Success(false));

    final updated = await applyShopBranchAvailability(
      cart: cart,
      branches: repository,
    );

    expect(updated.hasUnavailableLine, isTrue);
    expect(updated.lines.single.unavailable, isTrue);
  });
}
