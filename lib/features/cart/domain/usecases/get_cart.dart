import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';

class GetCart {
  const GetCart(this._repository);
  final CartRepository _repository;
  Future<Result<ShoppingCart>> call({String? accountId}) =>
      _repository.getCart(accountId: accountId);
}
