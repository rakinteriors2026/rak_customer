import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';

abstract class CartRepository {
  Future<Result<ShoppingCart>> getCart({String? accountId});
  Future<Result<ShoppingCart>> addItem({
    required String productId,
    String? accountId,
  });
  Future<Result<ShoppingCart>> setLineQuantity({
    required String lineId,
    required int quantity,
    String? accountId,
  });
}
