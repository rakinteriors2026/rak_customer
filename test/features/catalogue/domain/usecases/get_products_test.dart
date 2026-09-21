import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/catalogue_repository.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_products.dart';

class _MockCatalogueRepository extends Mock implements CatalogueRepository {}

void main() {
  late _MockCatalogueRepository repository;
  late GetProducts usecase;

  setUp(() {
    repository = _MockCatalogueRepository();
    usecase = GetProducts(repository);
  });

  test(
    'keeps the server sales_mode so the UI can pick the correct CTA',
    () async {
      final products = [
        const CatalogueProduct(
          id: '1',
          categoryId: 'c',
          name: 'Table',
          description: '',
          salesMode: SalesMode.fixedPrice,
          priceMinor: 100,
          currency: 'INR',
          specs: '',
          imageHint: 'table',
        ),
        const CatalogueProduct(
          id: '2',
          categoryId: 'c',
          name: 'Pendant',
          description: '',
          salesMode: SalesMode.madeToOrder,
          priceMinor: 200,
          currency: 'INR',
          specs: '',
          imageHint: 'light',
        ),
        const CatalogueProduct(
          id: '3',
          categoryId: 'c',
          name: 'Wardrobe',
          description: '',
          salesMode: SalesMode.quotationOnly,
          priceMinor: null,
          currency: 'INR',
          specs: '',
          imageHint: 'wardrobe',
        ),
      ];
      when(
        () => repository.getProducts(categoryId: null, cursor: null),
      ).thenAnswer((_) async => Success(PageResult(items: products)));

      final result = await usecase();
      final items = result.valueOrNull!.items;
      expect(items[0].canAddToCart, isTrue);
      expect(items[1].canAddToCart, isTrue);
      expect(items[2].canAddToCart, isFalse);
    },
  );
}
