import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/data/datasources/catalogue_local_datasource.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/catalogue_repository.dart';

class CatalogueRepositoryImpl implements CatalogueRepository {
  CatalogueRepositoryImpl(this._datasource);
  final CatalogueLocalDatasource _datasource;

  @override
  Future<Result<List<CatalogueCategory>>> getCategories() async {
    try {
      return Success(await _datasource.categories());
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<PageResult<CatalogueProduct>>> getProducts({
    String? categoryId,
    String? cursor,
  }) async {
    try {
      final items = await _datasource.products(categoryId: categoryId);
      return Success(PageResult(items: items));
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<CatalogueProduct>> getProduct(String id) async {
    try {
      return Success(await _datasource.product(id));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
