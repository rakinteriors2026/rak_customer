/// Remembers where a signed-out customer was trying to go.
class AuthReturn {
  static String? readFrom(Uri uri) {
    final from = uri.queryParameters['from'];
    if (from == null || from.isEmpty || from.startsWith('/login')) return null;
    return from;
  }

  static String loginLocation({String? from}) {
    if (from == null || from.isEmpty) return '/login';
    return '/login?from=${Uri.encodeComponent(from)}';
  }

  static String otpLocation({String? from}) {
    if (from == null || from.isEmpty) return '/login/otp';
    return '/login/otp?from=${Uri.encodeComponent(from)}';
  }

  /// Screen to restore when sign-in is cancelled.
  static String cancelDestination(String? requested) {
    if (requested == null || requested.isEmpty) return '/shop';
    final path = Uri.parse(requested).path;
    if (path.startsWith('/checkout') ||
        path.startsWith('/orders') ||
        path == '/address') {
      return '/cart';
    }
    if (path.startsWith('/projects')) return '/account';
    if (path.startsWith('/support')) return '/support';
    if (path.startsWith('/account')) return '/account';
    if (path.startsWith('/notifications')) return '/account';
    return '/shop';
  }
}
