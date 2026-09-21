import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_product.dart';

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(this.product, {this.busy = false, this.notice});
  final CatalogueProduct product;
  final bool busy;
  final String? notice;
}

class ProductDetailError extends ProductDetailState {
  const ProductDetailError(this.message);
  final String message;
}

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required GetProduct getProduct})
    : _getProduct = getProduct,
      super(const ProductDetailLoading());

  final GetProduct _getProduct;

  Future<void> load(String id) async {
    emit(const ProductDetailLoading());
    final result = await _getProduct(id);
    result.fold(
      onSuccess: (product) => emit(ProductDetailLoaded(product)),
      onFailure: (failure) => emit(ProductDetailError(failure.message)),
    );
  }

  void showNotice(String notice) {
    final current = state;
    if (current is ProductDetailLoaded) {
      emit(ProductDetailLoaded(current.product, notice: notice));
    }
  }
}
