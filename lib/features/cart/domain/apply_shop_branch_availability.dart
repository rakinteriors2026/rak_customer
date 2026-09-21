import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';

Future<ShoppingCart> applyShopBranchAvailability({
  required ShoppingCart cart,
  required ShopBranchRepository branches,
}) async {
  final lines = <CartLine>[];
  for (final line in cart.lines) {
    final result = await branches.isProductAvailable(productId: line.productId);
    final atBranch = result.valueOrNull ?? true;
    lines.add(line.copyWith(unavailable: line.unavailable || !atBranch));
  }
  return cart.copyWith(lines: lines);
}
