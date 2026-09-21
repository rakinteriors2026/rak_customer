class PhoneFormatter {
  static String masked(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return phone;
    final countryLen = digits.length > 10
        ? digits.length - 10
        : (digits.length - 6).clamp(1, 4);
    final country = digits.substring(0, countryLen);
    final last4 = digits.substring(digits.length - 4);
    final prefix = phone.startsWith('+') ? '+' : '';
    return '$prefix$country •••••• $last4';
  }

  static String firstName(String displayName) {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? displayName : parts.first;
  }

  static String greeting(DateTime now) {
    final hour = now.toLocal().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
