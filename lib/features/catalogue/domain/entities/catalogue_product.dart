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
    this.imageUrls = const [],
    this.modelGlbUrl,
    this.modelUsdzUrl,
    this.spinFrameUrls = const [],
  });

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final SalesMode salesMode;
  final int? priceMinor;
  final String currency;
  final String specs;

  /// Legacy visual key (`table`, `sofa`, …). Retained as a fallback for
  /// clients until every product carries real media URLs.
  final String imageHint;

  /// Gallery image URLs (http(s)) or bundled asset paths. First is primary.
  final List<String> imageUrls;

  /// glTF/GLB model for Android AR and generic 3D viewers. Null when the
  /// product has no 3D presentation yet.
  final String? modelGlbUrl;

  /// USDZ model for iOS AR Quick Look. Null when unavailable.
  final String? modelUsdzUrl;

  /// Ordered frames for a 360° spin viewer. Empty when unavailable.
  final List<String> spinFrameUrls;

  bool get canAddToCart =>
      salesMode == SalesMode.fixedPrice || salesMode == SalesMode.madeToOrder;

  /// Primary image source, preferring real media over the legacy hint.
  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Whether a 3D model exists for AR / 3D presentation.
  bool get hasModel => modelGlbUrl != null || modelUsdzUrl != null;

  /// Whether a 360° spin sequence exists.
  bool get hasSpin => spinFrameUrls.isNotEmpty;
}
