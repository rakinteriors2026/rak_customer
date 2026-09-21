import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';

class GetDeliveryAddress {
  const GetDeliveryAddress(this._repository);
  final CheckoutRepository _repository;

  Future<Result<DeliveryAddress?>> call({required String accountId}) {
    if (accountId.trim().isEmpty) {
      return Future.value(const Err(UnauthorizedFailure()));
    }
    return _repository.getAddress(accountId: accountId);
  }
}
