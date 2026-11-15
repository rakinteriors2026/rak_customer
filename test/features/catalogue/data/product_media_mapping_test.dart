import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/features/catalogue/data/datasources/catalogue_local_datasource.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';

import '../../../helpers/memory_database.dart';

void main() {
  group('CatalogueLocalDatasource media mapping', () {
    late AppDatabase db;
    late CatalogueLocalDatasource datasource;

    setUp(() async {
      db = createMemoryDatabase();
      await db.seedIfNeeded();
      datasource = CatalogueLocalDatasource(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('maps seeded image and model media onto the product', () async {
      final product = await datasource.product('prod_oak_table');
      expect(product.imageUrls, [
        'assets/showcase/piece_oak_table.jpg',
        'assets/showcase/showcase_hillview_dining.jpg',
      ]);
      expect(product.modelGlbUrl, 'assets/models/table.glb');
      expect(product.primaryImageUrl, 'assets/showcase/piece_oak_table.jpg');
      expect(product.hasModel, isTrue);
    });

    test('defaults list columns to empty when unseeded', () async {
      // Wardrobe is seeded with media; a product with no USDZ keeps it null.
      final product = await datasource.product('prod_wardrobe');
      expect(product.modelUsdzUrl, isNull);
      expect(product.spinFrameUrls, isEmpty);
      expect(product.hasSpin, isFalse);
    });
  });

  group('CatalogueProduct media getters', () {
    const base = CatalogueProduct(
      id: '1',
      categoryId: 'c',
      name: 'Table',
      description: '',
      salesMode: SalesMode.fixedPrice,
      priceMinor: 100,
      currency: 'INR',
      specs: '',
      imageHint: 'table',
    );

    test('defaults to no media', () {
      expect(base.primaryImageUrl, isNull);
      expect(base.hasModel, isFalse);
      expect(base.hasSpin, isFalse);
    });

    test('derives convenience flags from populated media', () {
      const product = CatalogueProduct(
        id: '1',
        categoryId: 'c',
        name: 'Table',
        description: '',
        salesMode: SalesMode.fixedPrice,
        priceMinor: 100,
        currency: 'INR',
        specs: '',
        imageHint: 'table',
        imageUrls: ['a.jpg', 'b.jpg'],
        modelGlbUrl: 'table.glb',
        spinFrameUrls: ['f0.png'],
      );
      expect(product.primaryImageUrl, 'a.jpg');
      expect(product.hasModel, isTrue);
      expect(product.hasSpin, isTrue);
    });
  });
}
