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
    final pin = postcode.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(pin)) {
      return Future.value(
        const Err(ValidationFailure('Enter a 6-digit delivery PIN.')),
      );
    }
    if (!RegExp(r'^(56|67|68|69)\d{4}$').hasMatch(pin)) {
      return Future.value(
        const Err(
          ValidationFailure(
            'This PIN is outside the demo delivery area. Try a Kochi, Trivandrum, Calicut, or Bengaluru PIN.',
          ),
        ),
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
