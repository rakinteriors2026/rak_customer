import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';

class UpdateShopOrderStatus {
  const UpdateShopOrderStatus(this._repository);
  final CheckoutRepository _repository;

  Future<Result<ShopOrder>> call({
    required String accountId,
    required String orderId,
    required String status,
  }) {
    if (accountId.trim().isEmpty) {
      return Future.value(const Err(UnauthorizedFailure()));
    }
    if (!ShopOrder.knownStatuses.contains(status)) {
      return Future.value(
        const Err(ValidationFailure('That order status is not available.')),
      );
    }
    return _repository.updateStatus(
      accountId: accountId,
      orderId: orderId,
      status: status,
    );
  }
}
