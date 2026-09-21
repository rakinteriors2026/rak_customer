enum SalesMode { fixedPrice, madeToOrder, quotationOnly }

SalesMode salesModeFromApi(String value) {
  return switch (value) {
    'made_to_order' => SalesMode.madeToOrder,
    'quotation_only' => SalesMode.quotationOnly,
    _ => SalesMode.fixedPrice,
  };
}

class CatalogueCategory {
  const CatalogueCategory({required this.id, required this.name});
  final String id;
  final String name;
}

class CatalogueProduct {
  const CatalogueProduct({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.salesMode,
    required this.priceMinor,
    required this.currency,
    required this.specs,
    required this.imageHint,
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final SalesMode salesMode;
  final int? priceMinor;
  final String currency;
  final String specs;
  final String imageHint;

  bool get canAddToCart =>
      salesMode == SalesMode.fixedPrice || salesMode == SalesMode.madeToOrder;
}
