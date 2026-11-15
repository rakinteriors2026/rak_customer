/// A RAK interior service shown on the storefront home.
///
/// Lightweight on purpose: the home screen only needs enough to draw a
/// card and deep link into the service. The full service (description,
/// flow, inclusions) lives in the services feature.
class HomeServiceItem {
  const HomeServiceItem({
    required this.id,
    required this.name,
    required this.tagline,
    required this.heroAsset,
  });

  final String id;
  final String name;
  final String tagline;
  final String heroAsset;
}
