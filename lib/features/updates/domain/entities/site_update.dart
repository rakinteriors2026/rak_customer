class SiteUpdateAssetRef {
  const SiteUpdateAssetRef({required this.assetId, required this.sortIndex});

  final String assetId;
  final int sortIndex;
}

class SiteUpdate {
  const SiteUpdate({
    required this.id,
    required this.projectId,
    required this.published,
    required this.note,
    required this.eventAt,
    required this.sortCursor,
    this.assets = const [],
  });

  final String id;
  final String projectId;
  final bool published;
  final String? note;
  final DateTime eventAt;
  final String sortCursor;
  final List<SiteUpdateAssetRef> assets;

  bool get isDraft => !published;
}
