import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';

class CatalogueLocalDatasource {
  CatalogueLocalDatasource(this._db);
  final AppDatabase _db;

  Future<List<CatalogueCategory>> categories() async {
    final rows = await (_db.select(
      _db.categories,
    )..orderBy([(t) => OrderingTerm.asc(t.sortIndex)])).get();
    return rows.map((r) => CatalogueCategory(id: r.id, name: r.name)).toList();
  }

  Future<List<CatalogueProduct>> products({String? categoryId}) async {
    final query = _db.select(_db.products)
      ..where((t) => t.published.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.sortCursor)]);
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    final rows = await query.get();
    return rows.map(_map).toList();
  }

  Future<CatalogueProduct> product(String id) async {
    final row =
        await (_db.select(_db.products)
              ..where((t) => t.id.equals(id) & t.published.equals(true)))
            .getSingleOrNull();
    if (row == null)
      throw const NotFoundFailure('This product is not available.');
    return _map(row);
  }

  CatalogueProduct _map(ProductRow row) => CatalogueProduct(
    id: row.id,
    categoryId: row.categoryId,
    name: row.name,
    description: row.description,
    salesMode: salesModeFromApi(row.salesMode),
    priceMinor: row.priceMinor,
    currency: row.currency,
    specs: row.specs,
    imageHint: row.imageHint,
  );
}
