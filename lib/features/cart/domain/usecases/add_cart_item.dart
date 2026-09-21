import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';

class AddCartItem {
  const AddCartItem(this._repository);
  final CartRepository _repository;

  Future<Result<ShoppingCart>> call({
    required String productId,
    String? accountId,
  }) {
    if (productId.isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Choose a product first.')),
      );
    }
    return _repository.addItem(productId: productId, accountId: accountId);
  }
}
