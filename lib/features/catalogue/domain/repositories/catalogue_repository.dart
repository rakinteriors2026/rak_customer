import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';

abstract class CatalogueRepository {
  Future<Result<List<CatalogueCategory>>> getCategories();
  Future<Result<PageResult<CatalogueProduct>>> getProducts({
    String? categoryId,
    String? cursor,
  });
  Future<Result<CatalogueProduct>> getProduct(String id);
}
