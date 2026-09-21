import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';

class ShopOrderLine {
  const ShopOrderLine({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageHint,
    required this.unitPriceMinor,
    required this.currency,
    required this.quantity,
  });

  final String id;
  final String productId;
  final String name;
  final String imageHint;
  final int unitPriceMinor;
  final String currency;
  final int quantity;
}

class ShopOrder {
  const ShopOrder({
    required this.id,
    required this.accountId,
    required this.status,
    required this.address,
    required this.lines,
    required this.totalMinor,
    required this.currency,
    required this.createdAt,
  });

  final String id;
  final String accountId;
  final String status;
  final DeliveryAddress address;
  final List<ShopOrderLine> lines;
  final int totalMinor;
  final String currency;
  final DateTime createdAt;

  bool get isConfirmed => status == 'confirmed';
}
