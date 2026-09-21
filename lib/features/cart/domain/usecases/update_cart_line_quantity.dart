import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartLineQuantity {
  const UpdateCartLineQuantity(this._repository);
  final CartRepository _repository;

  Future<Result<ShoppingCart>> call({
    required String lineId,
    required int quantity,
    String? accountId,
  }) {
    if (lineId.isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Choose a cart item first.')),
      );
    }
    return _repository.setLineQuantity(
      lineId: lineId,
      quantity: quantity,
      accountId: accountId,
    );
  }
}
