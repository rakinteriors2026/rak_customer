/// A finished RAK interior shown as a reference on the storefront home.
///
/// Lightweight on purpose: the home screen only needs enough to draw a
/// gallery card and deep link into the showcase. The full project (story,
/// rooms, pieces used) lives in the showcase feature.
class HomeShowcaseItem {
  const HomeShowcaseItem({
    required this.id,
    required this.title,
    required this.styleLabel,
    required this.locationLabel,
    required this.coverAsset,
  });

  final String id;
  final String title;
  final String styleLabel;
  final String locationLabel;
  final String coverAsset;
}
