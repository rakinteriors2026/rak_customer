import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/features/cart/domain/apply_shop_branch_availability.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_delivery_address.dart';

sealed class CheckoutState {
  const CheckoutState();
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading();
}

class CheckoutReady extends CheckoutState {
  const CheckoutReady({required this.cart, this.address});

  final ShoppingCart cart;
  final DeliveryAddress? address;
}

class CheckoutEmpty extends CheckoutState {
  const CheckoutEmpty();
}

class CheckoutError extends CheckoutState {
  const CheckoutError(this.message);
  final String message;
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required GetCart getCart,
    required GetDeliveryAddress getDeliveryAddress,
    required ShopBranchRepository shopBranchRepository,
    required this.accountId,
  }) : _getCart = getCart,
       _getDeliveryAddress = getDeliveryAddress,
       _shopBranchRepository = shopBranchRepository,
       super(const CheckoutLoading()) {
    _branchSub = _shopBranchRepository.watchSelected().skip(1).listen((_) {
      unawaited(_reapplyAvailability());
    });
  }

  final GetCart _getCart;
  final GetDeliveryAddress _getDeliveryAddress;
  final ShopBranchRepository _shopBranchRepository;
  final String accountId;
  late final StreamSubscription<ShopBranch> _branchSub;
  ShoppingCart? _rawCart;
  DeliveryAddress? _address;

  Future<void> load() async {
    emit(const CheckoutLoading());
    final cartResult = await _getCart(accountId: accountId);
    if (isClosed) return;
    if (cartResult.isFailure) {
      emit(CheckoutError(cartResult.failureOrNull!.message));
      return;
    }
    final cart = cartResult.valueOrNull!;
    _rawCart = cart;
    if (cart.isEmpty) {
      emit(const CheckoutEmpty());
      return;
    }
    final addressResult = await _getDeliveryAddress(accountId: accountId);
    if (isClosed) return;
    if (addressResult.isFailure) {
      emit(CheckoutError(addressResult.failureOrNull!.message));
      return;
    }
    _address = addressResult.valueOrNull;
    emit(CheckoutReady(cart: await _annotate(cart), address: _address));
  }

  Future<void> _reapplyAvailability() async {
    final raw = _rawCart;
    if (raw == null || raw.isEmpty || isClosed) return;
    if (state is! CheckoutReady) return;
    emit(CheckoutReady(cart: await _annotate(raw), address: _address));
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
