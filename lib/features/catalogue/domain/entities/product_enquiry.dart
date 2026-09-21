class ProductEnquiry {
  const ProductEnquiry({
    required this.id,
    required this.message,
    required this.createdAt,
    this.accountId,
    this.productId,
  });

  final String id;
  final String message;
  final DateTime createdAt;
  final String? accountId;
  final String? productId;
}
