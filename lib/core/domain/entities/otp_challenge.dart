class OtpChallenge {
  const OtpChallenge({
    required this.id,
    required this.phone,
    required this.expiresAt,
    required this.resendAfter,
  });

  final String id;
  final String phone;
  final DateTime expiresAt;
  final DateTime resendAfter;

  @override
  bool operator ==(Object other) =>
      other is OtpChallenge &&
      other.id == id &&
      other.phone == phone &&
      other.expiresAt == expiresAt &&
      other.resendAfter == resendAfter;

  @override
  int get hashCode => Object.hash(id, phone, expiresAt, resendAfter);
}
