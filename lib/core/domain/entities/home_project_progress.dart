class HomeProjectProgress {
  const HomeProjectProgress({
    required this.id,
    required this.name,
    required this.siteLabel,
    required this.phaseLabel,
    required this.progressPercent,
  });

  final String id;
  final String name;
  final String siteLabel;
  final String phaseLabel;

  /// Null when RAK has not published a progress figure for this project.
  final int? progressPercent;
}
