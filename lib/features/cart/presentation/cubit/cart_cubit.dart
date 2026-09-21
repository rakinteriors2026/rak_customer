import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/features/cart/domain/apply_shop_branch_availability.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/update_cart_line_quantity.dart';

sealed class CartState {
  const CartState();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartLoaded extends CartState {
  const CartLoaded(this.cart);
  final ShoppingCart cart;
}

class CartError extends CartState {
  const CartError(this.message);
  final String message;
}

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required GetCart getCart,
    required UpdateCartLineQuantity updateCartLineQuantity,
    required ShopBranchRepository shopBranchRepository,
  }) : _getCart = getCart,
       _updateCartLineQuantity = updateCartLineQuantity,
       _shopBranchRepository = shopBranchRepository,
       super(const CartLoading()) {
    _branchSub = _shopBranchRepository.watchSelected().skip(1).listen((_) {
      unawaited(_reapplyAvailability());
    });
  }

  final GetCart _getCart;
  final UpdateCartLineQuantity _updateCartLineQuantity;
  final ShopBranchRepository _shopBranchRepository;
  late final StreamSubscription<ShopBranch> _branchSub;
  ShoppingCart? _rawCart;

  Future<void> load({String? accountId}) async {
    emit(const CartLoading());
    final result = await _getCart(accountId: accountId);
    if (isClosed) return;
    if (result.isFailure) {
      emit(CartError(result.failureOrNull!.message));
      return;
    }
    await _emitCart(result.valueOrNull!);
  }

  Future<void> setQuantity({
    required String lineId,
    required int quantity,
    String? accountId,
  }) async {
    final result = await _updateCartLineQuantity(
      lineId: lineId,
      quantity: quantity,
      accountId: accountId,
    );
    if (isClosed) return;
    if (result.isFailure) {
      emit(CartError(result.failureOrNull!.message));
      return;
    }
    await _emitCart(result.valueOrNull!);
  }

  Future<void> _emitCart(ShoppingCart cart) async {
    _rawCart = cart;
    if (cart.isEmpty) {
      emit(const CartEmpty());
      return;
    }
    emit(CartLoaded(await _annotate(cart)));
  }

  Future<void> _reapplyAvailability() async {
    final raw = _rawCart;
    if (raw == null || isClosed) return;
    if (raw.isEmpty) {
      emit(const CartEmpty());
      return;
    }
    emit(CartLoaded(await _annotate(raw)));
  }

  Future<ShoppingCart> _annotate(ShoppingCart cart) {
    return applyShopBranchAvailability(
      cart: cart,
      branches: _shopBranchRepository,
    );
  }

  @override
  Future<void> close() {
    _branchSub.cancel();
    return super.close();
  }
}
