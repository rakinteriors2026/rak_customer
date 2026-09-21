import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/list_shop_orders.dart';

sealed class OrdersListState {
  const OrdersListState();
}

class OrdersListLoading extends OrdersListState {
  const OrdersListLoading();
}

class OrdersListEmpty extends OrdersListState {
  const OrdersListEmpty();
}

class OrdersListLoaded extends OrdersListState {
  const OrdersListLoaded(this.orders);
  final List<ShopOrder> orders;
}

class OrdersListError extends OrdersListState {
  const OrdersListError(this.message);
  final String message;
}

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit({
    required ListShopOrders listShopOrders,
    required this.accountId,
  }) : _listShopOrders = listShopOrders,
       super(const OrdersListLoading());

  final ListShopOrders _listShopOrders;
  final String accountId;

  Future<void> load() async {
    emit(const OrdersListLoading());
    final result = await _listShopOrders(accountId: accountId);
    result.fold(
      onSuccess: (orders) => emit(
        orders.isEmpty ? const OrdersListEmpty() : OrdersListLoaded(orders),
      ),
      onFailure: (failure) => emit(OrdersListError(failure.message)),
    );
  }
}
