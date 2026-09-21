import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_categories.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_products.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';

class _MockGetCategories extends Mock implements GetCategories {}

class _MockGetProducts extends Mock implements GetProducts {}

void main() {
  late _MockGetCategories getCategories;
  late _MockGetProducts getProducts;
  late CatalogueCubit cubit;

  const categories = [
    CatalogueCategory(id: 'cat_furniture', name: 'Furniture'),
    CatalogueCategory(id: 'cat_decor', name: 'Decor'),
  ];

  const products = [
    CatalogueProduct(
      id: '1',
      categoryId: 'cat_furniture',
      name: 'Oak dining table',
      description: '',
      salesMode: SalesMode.fixedPrice,
      priceMinor: 100,
      currency: 'INR',
      specs: '',
      imageHint: 'table',
    ),
    CatalogueProduct(
      id: '2',
      categoryId: 'cat_decor',
      name: 'Wool rug',
      description: '',
      salesMode: SalesMode.fixedPrice,
      priceMinor: 200,
      currency: 'INR',
      specs: '',
      imageHint: 'rug',
    ),
  ];

  setUp(() {
    getCategories = _MockGetCategories();
    getProducts = _MockGetProducts();
    when(
      () => getCategories(),
    ).thenAnswer((_) async => const Success(categories));
    when(
      () => getProducts(),
    ).thenAnswer((_) async => const Success(PageResult(items: products)));
    cubit = CatalogueCubit(
      getCategories: getCategories,
      getProducts: getProducts,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test(
    'selectCategory filters in memory and never emits CatalogueLoading',
    () async {
      await cubit.load();
      expect(cubit.state, isA<CatalogueLoaded>());
      verify(() => getProducts()).called(1);

      final emitted = <CatalogueState>[];
      final sub = cubit.stream.listen(emitted.add);

      cubit.selectCategory('cat_furniture');
      await Future<void>.delayed(Duration.zero);

      expect(emitted, hasLength(1));
      expect(emitted.single, isA<CatalogueLoaded>());
      final loaded = emitted.single as CatalogueLoaded;
      expect(loaded.selectedCategoryId, 'cat_furniture');
      expect(loaded.products, [products.first]);
      expect(loaded.allProducts, products);

      await sub.cancel();
    },
  );

  test('selecting the same category is a no-op', () async {
    await cubit.load();
    cubit.selectCategory('cat_decor');

    final emitted = <CatalogueState>[];
    final sub = cubit.stream.listen(emitted.add);
    cubit.selectCategory('cat_decor');
    await Future<void>.delayed(Duration.zero);

    expect(emitted, isEmpty);
    await sub.cancel();
  });
}
