import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/catalogue_repository.dart';

class GetCategories {
  const GetCategories(this._repository);
  final CatalogueRepository _repository;
  Future<Result<List<CatalogueCategory>>> call() => _repository.getCategories();
}
