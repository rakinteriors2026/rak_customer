/// A completed RAK interior project, used as reference work in the app.
class ShowcaseProject {
  const ShowcaseProject({
    required this.id,
    required this.title,
    required this.styleLabel,
    required this.locationLabel,
    required this.homeType,
    required this.summary,
    required this.story,
    required this.scopeLabel,
    required this.coverAsset,
    required this.gallery,
    required this.pieces,
  });

  final String id;
  final String title;

  /// Design language, e.g. "Warm contemporary".
  final String styleLabel;

  /// City or area, e.g. "Kumarakom, Kerala".
  final String locationLabel;

  /// e.g. "4 BHK villa".
  final String homeType;

  /// One line under the title.
  final String summary;

  /// A short paragraph describing the approach.
  final String story;

  /// Rooms covered, e.g. "Living, kitchen, bedrooms".
  final String scopeLabel;

  final String coverAsset;

  /// Room photographs for the detail gallery.
  final List<ShowcaseImage> gallery;

  /// Furniture and finishes used in this home.
  final List<ShowcasePiece> pieces;
}

/// A single room photograph with an optional caption.
class ShowcaseImage {
  const ShowcaseImage({required this.asset, this.caption});

  final String asset;
  final String? caption;
}

/// A furniture piece or finish used in a [ShowcaseProject].
///
/// When [productId] is set the piece is also sold in the shop and can be
/// opened at `/shop/products/:productId`. When it is null the piece is a
/// finish or bespoke item without a catalogue entry.
class ShowcasePiece {
  const ShowcasePiece({
    required this.name,
    required this.categoryLabel,
    required this.imageAsset,
    this.productId,
    this.note,
  });

  final String name;
  final String categoryLabel;
  final String imageAsset;
  final String? productId;
  final String? note;

  bool get isInShop => productId != null;
}
