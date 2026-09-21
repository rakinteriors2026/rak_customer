import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';

class ListShopOrders {
  const ListShopOrders(this._repository);
  final CheckoutRepository _repository;

  Future<Result<List<ShopOrder>>> call({required String accountId}) {
    if (accountId.trim().isEmpty) {
      return Future.value(const Err(UnauthorizedFailure()));
    }
    return _repository.listOrders(accountId: accountId);
  }
}
