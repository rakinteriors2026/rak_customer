import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/update_shop_order_status.dart';

sealed class OrderTrackingState {
  const OrderTrackingState();
}

class OrderTrackingLoading extends OrderTrackingState {
  const OrderTrackingLoading();
}

class OrderTrackingLoaded extends OrderTrackingState {
  const OrderTrackingLoaded(this.order);
  final ShopOrder order;
}

class OrderTrackingError extends OrderTrackingState {
  const OrderTrackingError(this.message);
  final String message;
}

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit({
    required GetShopOrder getShopOrder,
    required UpdateShopOrderStatus updateShopOrderStatus,
    required this.accountId,
    required this.orderId,
  }) : _getShopOrder = getShopOrder,
       _updateShopOrderStatus = updateShopOrderStatus,
       super(const OrderTrackingLoading());

  final GetShopOrder _getShopOrder;
  final UpdateShopOrderStatus _updateShopOrderStatus;
  final String accountId;
  final String orderId;

  Future<void> load() async {
    emit(const OrderTrackingLoading());
    final result = await _getShopOrder(accountId: accountId, orderId: orderId);
    result.fold(
      onSuccess: (order) => emit(OrderTrackingLoaded(order)),
      onFailure: (failure) => emit(OrderTrackingError(failure.message)),
    );
  }

  Future<void> advance(String status) async {
    final result = await _updateShopOrderStatus(
      accountId: accountId,
      orderId: orderId,
      status: status,
    );
    result.fold(
      onSuccess: (order) => emit(OrderTrackingLoaded(order)),
      onFailure: (failure) => emit(OrderTrackingError(failure.message)),
    );
  }
}
