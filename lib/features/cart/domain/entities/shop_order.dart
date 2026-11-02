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

  static const knownStatuses = {
    'confirmed',
    'preparing',
    'dispatched',
    'delivered',
    'cancellation_requested',
    'under_review',
    'cancellation_rejected',
    'cancelled',
    'return_requested',
    'refund_initiated',
    'refund_completed',
  };

  static const fulfilmentSteps = [
    'confirmed',
    'preparing',
    'dispatched',
    'delivered',
  ];

  /// Demo cutoff only. Real cancellation windows stay with RAK.
  static const cancellableStatuses = {'confirmed', 'preparing'};
  static const returnableStatuses = {'dispatched', 'delivered'};

  bool get isConfirmed => status == 'confirmed';

  String get statusLabel => switch (status) {
    'confirmed' => 'Confirmed',
    'preparing' => 'Preparing',
    'dispatched' => 'Dispatched',
    'delivered' => 'Delivered',
    'cancellation_requested' => 'Cancellation requested',
    'under_review' => 'Under review',
    'cancellation_rejected' => 'Cancellation declined',
    'cancelled' => 'Cancelled',
    'return_requested' => 'Return requested',
    'refund_initiated' => 'Refund initiated',
    'refund_completed' => 'Refund completed',
    _ => status,
  };

  String? get nextFulfilmentStatus {
    final index = fulfilmentSteps.indexOf(status);
    if (index < 0 || index == fulfilmentSteps.length - 1) return null;
    return fulfilmentSteps[index + 1];
  }

  bool get canRequestCancellation => cancellableStatuses.contains(status);

  bool get canRequestReturn => returnableStatuses.contains(status);
}
