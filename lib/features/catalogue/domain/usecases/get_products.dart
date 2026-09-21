import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/catalogue_repository.dart';

class GetProducts {
  const GetProducts(this._repository);
  final CatalogueRepository _repository;

  Future<Result<PageResult<CatalogueProduct>>> call({String? categoryId}) {
    return _repository.getProducts(categoryId: categoryId);
  }
}
