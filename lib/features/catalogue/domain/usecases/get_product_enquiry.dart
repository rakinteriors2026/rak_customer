import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';

class GetProductEnquiry {
  const GetProductEnquiry(this._repository);
  final EnquiryRepository _repository;

  Future<Result<ProductEnquiry>> call(String enquiryId) {
    return _repository.getEnquiry(enquiryId);
  }
}
