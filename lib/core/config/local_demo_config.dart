class LocalDemoConfig {
  static const demoOtpCode = '123456';
  static const otpTtl = Duration(minutes: 5);
  static const resendCooldown = Duration(seconds: 30);
  static const accessTokenTtl = Duration(hours: 12);
  static const assetAccessTtl = Duration(minutes: 2);
  static const ledgerStaleAfter = Duration(hours: 24);

  static const projectsAccountPhone = '+919876540001';
  static const buyerOnlyPhone = '+919876540002';
}
