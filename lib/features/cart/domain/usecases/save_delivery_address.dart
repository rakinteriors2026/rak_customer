import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';

class SaveDeliveryAddress {
  const SaveDeliveryAddress(this._repository);
  final CheckoutRepository _repository;

  Future<Result<DeliveryAddress>> call({
    required String accountId,
    required String fullName,
    required String mobile,
    required String line,
    required String postcode,
  }) {
    if (accountId.trim().isEmpty) {
      return Future.value(const Err(UnauthorizedFailure()));
    }
    if (fullName.trim().isEmpty ||
        mobile.trim().isEmpty ||
        line.trim().isEmpty ||
        postcode.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Fill in every delivery field.')),
      );
    }
    return _repository.saveAddress(
      accountId: accountId,
      fullName: fullName,
      mobile: mobile,
      line: line,
      postcode: postcode,
    );
  }
}
