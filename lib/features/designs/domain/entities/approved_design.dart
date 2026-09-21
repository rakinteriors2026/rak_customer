class ApprovedDesign {
  const ApprovedDesign({
    required this.id,
    required this.projectId,
    required this.title,
    required this.versionLabel,
    required this.assetIds,
  });

  final String id;
  final String projectId;
  final String title;
  final String versionLabel;
  final List<String> assetIds;
}
