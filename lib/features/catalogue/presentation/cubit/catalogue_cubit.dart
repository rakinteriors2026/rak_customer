import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_categories.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_products.dart';

sealed class CatalogueState {
  const CatalogueState();
}

class CatalogueLoading extends CatalogueState {
  const CatalogueLoading();
}

class CatalogueEmpty extends CatalogueState {
  const CatalogueEmpty();
}

class CatalogueLoaded extends CatalogueState {
  const CatalogueLoaded({
    required this.categories,
    required this.allProducts,
    this.selectedCategoryId,
  });

  final List<CatalogueCategory> categories;
  final List<CatalogueProduct> allProducts;
  final String? selectedCategoryId;

  List<CatalogueProduct> get products {
    final categoryId = selectedCategoryId;
    if (categoryId == null) return allProducts;
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList(growable: false);
  }

  CatalogueLoaded copyWith({
    List<CatalogueCategory>? categories,
    List<CatalogueProduct>? allProducts,
    String? selectedCategoryId,
    bool clearCategory = false,
  }) {
    return CatalogueLoaded(
      categories: categories ?? this.categories,
      allProducts: allProducts ?? this.allProducts,
      selectedCategoryId: clearCategory
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }
}

class CatalogueError extends CatalogueState {
  const CatalogueError(this.message);
  final String message;
}

class CatalogueCubit extends Cubit<CatalogueState> {
  CatalogueCubit({
    required GetCategories getCategories,
    required GetProducts getProducts,
  }) : _getCategories = getCategories,
       _getProducts = getProducts,
       super(const CatalogueLoading());

  final GetCategories _getCategories;
  final GetProducts _getProducts;

  Future<void> load({String? categoryId}) async {
    final keepContent = state is CatalogueLoaded;
    if (!keepContent) {
      emit(const CatalogueLoading());
    }

    final categoriesResult = await _getCategories();
    final productsResult = await _getProducts();

    if (categoriesResult.isFailure) {
      emit(CatalogueError(categoriesResult.failureOrNull!.message));
      return;
    }
    if (productsResult.isFailure) {
      emit(CatalogueError(productsResult.failureOrNull!.message));
      return;
    }

    final products = productsResult.valueOrNull!.items;
    if (products.isEmpty) {
      emit(const CatalogueEmpty());
      return;
    }
    emit(
      CatalogueLoaded(
        categories: categoriesResult.valueOrNull!,
        allProducts: products,
        selectedCategoryId: categoryId,
      ),
    );
  }

  void selectCategory(String? categoryId) {
    final current = state;
    if (current is! CatalogueLoaded) {
      load(categoryId: categoryId);
      return;
    }
    if (current.selectedCategoryId == categoryId) return;
    emit(
      current.copyWith(
        selectedCategoryId: categoryId,
        clearCategory: categoryId == null,
      ),
    );
  }
}
