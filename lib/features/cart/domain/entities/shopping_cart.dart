class CartLine {
  const CartLine({
    required this.id,
    required this.productId,
    required this.name,
    required this.unitPriceMinor,
    required this.currency,
    required this.quantity,
    required this.unavailable,
    required this.repriced,
    this.imageHint = 'placeholder',
  });

  final String id;
  final String productId;
  final String name;
  final int unitPriceMinor;
  final String currency;
  final int quantity;
  final bool unavailable;
  final bool repriced;
  final String imageHint;

  CartLine copyWith({bool? unavailable}) {
    return CartLine(
      id: id,
      productId: productId,
      name: name,
      unitPriceMinor: unitPriceMinor,
      currency: currency,
      quantity: quantity,
      unavailable: unavailable ?? this.unavailable,
      repriced: repriced,
      imageHint: imageHint,
    );
  }
}

class ShoppingCart {
  const ShoppingCart({
    required this.id,
    required this.lines,
    required this.totalMinor,
    required this.currency,
    required this.version,
  });

  final String id;
  final List<CartLine> lines;
  final int totalMinor;
  final String currency;
  final int version;

  bool get isEmpty => lines.isEmpty;

  bool get hasUnavailableLine => lines.any((line) => line.unavailable);

  ShoppingCart copyWith({List<CartLine>? lines}) {
    return ShoppingCart(
      id: id,
      lines: lines ?? this.lines,
      totalMinor: totalMinor,
      currency: currency,
      version: version,
    );
  }
}
