import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';

class UpdateEnquiryStatus {
  const UpdateEnquiryStatus(this._repository);
  final EnquiryRepository _repository;

  Future<Result<ProductEnquiry>> call({
    required String enquiryId,
    required String status,
  }) {
    if (!ProductEnquiry.knownStatuses.contains(status)) {
      return Future.value(
        const Err(ValidationFailure('That enquiry status is not available.')),
      );
    }
    return _repository.updateStatus(enquiryId: enquiryId, status: status);
  }
}
