import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/place_order.dart';

sealed class PlaceOrderState {
  const PlaceOrderState();
}

class PlaceOrderIdle extends PlaceOrderState {
  const PlaceOrderIdle();
}

class PlaceOrderInProgress extends PlaceOrderState {
  const PlaceOrderInProgress();
}

class PlaceOrderSuccess extends PlaceOrderState {
  const PlaceOrderSuccess(this.order);
  final ShopOrder order;
}

class PlaceOrderFailure extends PlaceOrderState {
  const PlaceOrderFailure(this.message);
  final String message;
}

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  PlaceOrderCubit({required PlaceOrder placeOrder, required this.accountId})
    : _placeOrder = placeOrder,
      super(const PlaceOrderIdle());

  final PlaceOrder _placeOrder;
  final String accountId;

  Future<void> submit() async {
    if (state is PlaceOrderInProgress || state is PlaceOrderSuccess) return;
    emit(const PlaceOrderInProgress());
    final result = await _placeOrder(accountId: accountId);
    if (isClosed) return;
    result.fold(
      onSuccess: (order) => emit(PlaceOrderSuccess(order)),
      onFailure: (failure) => emit(PlaceOrderFailure(failure.message)),
    );
  }
}
