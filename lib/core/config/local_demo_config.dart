class LocalDemoConfig {
  /// Single source of truth for whether demo-only behaviour (fixed OTP,
  /// seeded demo accounts) is allowed to run.
  ///
  /// - Debug / profile builds: always `true`.
  /// - Release builds: `true` only when compiled with
  ///   `--dart-define=ALLOW_DEMO=true` (stakeholder demos / TestFlight).
  /// - Release builds without the flag: `false` (fail closed).
  ///
  /// Implemented with compile-time environment constants so this file stays
  /// pure Dart (no Flutter import) and a plain `flutter build --release`
  /// ships with the demo bypass unreachable.
  static const bool _isProductBuild = bool.fromEnvironment('dart.vm.product');
  static const bool _allowDemoInRelease = bool.fromEnvironment('ALLOW_DEMO');
  static const bool demoModeEnabled = !_isProductBuild || _allowDemoInRelease;

  /// True only when demo mode is active inside a release build. The UI shows a
  /// persistent "Demo build" banner in this case so it can't be mistaken for
  /// production.
  static const bool isReleaseDemoBuild = _isProductBuild && _allowDemoInRelease;

  static const demoOtpCode = '123456';
  static const otpTtl = Duration(minutes: 5);
  static const resendCooldown = Duration(seconds: 30);
  static const accessTokenTtl = Duration(hours: 12);
  static const assetAccessTtl = Duration(minutes: 2);
  static const ledgerStaleAfter = Duration(hours: 24);

  static const projectsAccountPhone = '+919876540001';
  static const buyerOnlyPhone = '+919876540002';
}
