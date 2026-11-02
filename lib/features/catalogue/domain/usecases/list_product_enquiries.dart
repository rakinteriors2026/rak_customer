import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';

class ListProductEnquiries {
  const ListProductEnquiries(this._repository);
  final EnquiryRepository _repository;

  Future<Result<List<ProductEnquiry>>> call({String? accountId}) {
    return _repository.listEnquiries(accountId: accountId);
  }
}
