import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';

class SubmitProductEnquiry {
  const SubmitProductEnquiry(this._repository);
  final EnquiryRepository _repository;

  Future<Result<ProductEnquiry>> call({
    required String message,
    String? productId,
    String? accountId,
  }) {
    if (message.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Tell us about the piece and your space.')),
      );
    }
    return _repository.submitEnquiry(
      message: message,
      productId: productId,
      accountId: accountId,
    );
  }
}
