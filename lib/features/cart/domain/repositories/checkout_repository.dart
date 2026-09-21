import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';

abstract class CheckoutRepository {
  Future<Result<DeliveryAddress?>> getAddress({required String accountId});

  Future<Result<DeliveryAddress>> saveAddress({
    required String accountId,
    required String fullName,
    required String mobile,
    required String line,
    required String postcode,
  });

  Future<Result<ShopOrder>> placeOrder({required String accountId});

  Future<Result<ShopOrder>> getOrder({
    required String accountId,
    required String orderId,
  });

  Future<Result<List<ShopOrder>>> listOrders({required String accountId});
}
