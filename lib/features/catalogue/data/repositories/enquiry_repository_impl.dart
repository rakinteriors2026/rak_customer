import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/data/datasources/enquiry_local_datasource.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';

class EnquiryRepositoryImpl implements EnquiryRepository {
  EnquiryRepositoryImpl(this._datasource);
  final EnquiryLocalDatasource _datasource;

  @override
  Future<Result<ProductEnquiry>> submitEnquiry({
    required String message,
    String? productId,
    String? accountId,
  }) async {
    try {
      return Success(
        await _datasource.submit(
          message: message,
          productId: productId,
          accountId: accountId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
