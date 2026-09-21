class AssetAccess {
  const AssetAccess({
    required this.assetId,
    required this.signedUrl,
    required this.expiresAt,
    required this.visualHint,
    this.caption,
  });

  final String assetId;
  final String signedUrl;
  final DateTime expiresAt;
  final String visualHint;
  final String? caption;

  bool isExpiredAt(DateTime now) => !expiresAt.isAfter(now.toUtc());
}
