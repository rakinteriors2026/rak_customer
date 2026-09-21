import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:rak_customer/shared/widgets/product_artwork.dart';

void main() {
  const table = CatalogueProduct(
    id: 'prod_oak_table',
    categoryId: 'cat_furniture',
    name: 'Oak dining table',
    description: 'Solid oak',
    salesMode: SalesMode.fixedPrice,
    priceMinor: 1850000,
    currency: 'INR',
    specs: 'W 220cm',
    imageHint: 'table',
  );

  testWidgets('product card does not overflow at large text scale', (
    tester,
  ) async {
    final overflows = <Object>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      overflows.add(details.exception);
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(390, 844),
            textScaler: TextScaler.linear(2),
          ),
          child: BlocProvider(
            create: (_) => FavouritesCubit(),
            child: Scaffold(
              body: GridView.builder(
                itemCount: 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 620,
                ),
                itemBuilder: (context, index) =>
                    ProductCard(product: table, onTap: () {}),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      overflows.where((error) => error.toString().contains('overflowed')),
      isEmpty,
    );
    expect(find.text('Oak dining table'), findsOneWidget);
  });

  test('artwork assets differ by product image hint', () {
    expect(
      ProductArtwork.assetFor('table'),
      'assets/products/linen_lounge_chair.png',
    );
    expect(
      ProductArtwork.assetFor('sofa'),
      'assets/products/oak_accent_chair.png',
    );
    expect(
      ProductArtwork.assetFor('light'),
      'assets/products/sage_lounge_chair.png',
    );
    expect(
      ProductArtwork.assetFor('wardrobe'),
      'assets/products/studio_armchair.png',
    );
    expect(
      ProductArtwork.assetFor('rug'),
      'assets/products/linen_lounge_chair.png',
    );
    expect(ProductArtwork.assetFor('unknown'), ProductArtwork.placeholderAsset);
    expect(
      ProductArtwork.assetFor('table'),
      isNot(ProductArtwork.assetFor('sofa')),
    );
  });
}
