import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_categories.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_products.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/shop_extra_pages.dart';

import '../../../helpers/memory_database.dart';

class _MockGetCategories extends Mock implements GetCategories {}

class _MockGetProducts extends Mock implements GetProducts {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const table = CatalogueProduct(
    id: 'prod_oak_table',
    categoryId: 'cat_furniture',
    name: 'Oak dining table',
    description: '',
    salesMode: SalesMode.fixedPrice,
    priceMinor: 100,
    currency: 'INR',
    specs: '',
    imageHint: 'table',
  );

  setUp(() async {
    if (sl.isRegistered<SessionCubit>()) {
      await sl.reset();
    }
    await configureDependencies(
      database: createMemoryDatabase(),
      sessionStorage: InMemorySessionStorage(),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  void useCatalogue({
    required GetCategories getCategories,
    required GetProducts getProducts,
  }) {
    sl.unregister<CatalogueCubit>();
    sl.registerFactory(
      () => CatalogueCubit(
        getCategories: getCategories,
        getProducts: getProducts,
      ),
    );
  }

  testWidgets(
    'search shows empty instead of loading when the catalogue is empty',
    (tester) async {
      final getCategories = _MockGetCategories();
      final getProducts = _MockGetProducts();
      when(() => getCategories()).thenAnswer((_) async => const Success([]));
      when(() => getProducts()).thenAnswer(
        (_) async => const Success(PageResult(items: <CatalogueProduct>[])),
      );
      useCatalogue(getCategories: getCategories, getProducts: getProducts);

      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light(), home: const SearchPage()),
      );
      await tester.pumpAndSettle();

      expect(find.text('No products found'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets('search shows an error with retry instead of loading', (
    tester,
  ) async {
    final getCategories = _MockGetCategories();
    final getProducts = _MockGetProducts();
    when(() => getCategories()).thenAnswer((_) async => const Success([]));
    when(() => getProducts()).thenAnswer(
      (_) async => const Err(UnknownFailure('Catalogue unavailable')),
    );
    useCatalogue(getCategories: getCategories, getProducts: getProducts);

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const SearchPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Catalogue unavailable'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
    'favourites shows empty when saved ids are missing from the catalogue',
    (tester) async {
      sl<FavouritesCubit>().toggle('prod_missing');
      final getCategories = _MockGetCategories();
      final getProducts = _MockGetProducts();
      when(() => getCategories()).thenAnswer(
        (_) async => const Success([
          CatalogueCategory(id: 'cat_furniture', name: 'Furniture'),
        ]),
      );
      when(
        () => getProducts(),
      ).thenAnswer((_) async => const Success(PageResult(items: [table])));
      useCatalogue(getCategories: getCategories, getProducts: getProducts);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: BlocProvider.value(
            value: sl<FavouritesCubit>(),
            child: const FavouritesPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing saved is available'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );
}
