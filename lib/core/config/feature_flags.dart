class FeatureFlags {
  const FeatureFlags({
    this.trackingEnabled = true,
    this.commerceEnabled = true,
  });

  final bool trackingEnabled;
  final bool commerceEnabled;
}
