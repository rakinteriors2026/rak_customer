import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';

abstract class EnquiryRepository {
  Future<Result<ProductEnquiry>> submitEnquiry({
    required String message,
    String? productId,
    String? accountId,
  });

  Future<Result<ProductEnquiry>> getEnquiry(String enquiryId);

  Future<Result<List<ProductEnquiry>>> listEnquiries({String? accountId});

  Future<Result<ProductEnquiry>> updateStatus({
    required String enquiryId,
    required String status,
  });
}
