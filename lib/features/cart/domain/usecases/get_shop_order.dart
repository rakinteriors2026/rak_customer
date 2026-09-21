import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';

class GetShopOrder {
  const GetShopOrder(this._repository);
  final CheckoutRepository _repository;

  Future<Result<ShopOrder>> call({
    required String accountId,
    required String orderId,
  }) {
    if (accountId.trim().isEmpty) {
      return Future.value(const Err(UnauthorizedFailure()));
    }
    if (orderId.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Choose an order to track.')),
      );
    }
    return _repository.getOrder(accountId: accountId, orderId: orderId);
  }
}
