/// An interior design service RAK offers to customers.
///
/// Pure Dart reference content used to show clients what RAK can do and how
/// a typical engagement flows, from first consultation to handover.
class InteriorService {
  const InteriorService({
    required this.id,
    required this.name,
    required this.tagline,
    required this.heroAsset,
    required this.summary,
    required this.description,
    required this.durationLabel,
    required this.startingPriceLabel,
    required this.highlights,
    required this.steps,
  });

  final String id;
  final String name;

  /// Short line shown on cards, e.g. "Cook, store and gather".
  final String tagline;

  final String heroAsset;

  /// One line under the title on the detail page.
  final String summary;

  /// A short paragraph describing the service.
  final String description;

  /// e.g. "4–6 weeks".
  final String durationLabel;

  /// e.g. "From ₹1.5L".
  final String startingPriceLabel;

  /// What the service includes.
  final List<String> highlights;

  /// The engagement flow, shown as a numbered journey on the detail page.
  final List<ServiceStep> steps;
}

/// A single step in a service's engagement flow.
class ServiceStep {
  const ServiceStep({required this.title, required this.detail});

  final String title;
  final String detail;
}
