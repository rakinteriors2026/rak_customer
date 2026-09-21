import 'package:rak_customer/core/domain/entities/account.dart';

class Session {
  const Session({
    required this.account,
    required this.accessToken,
    required this.refreshToken,
  });

  final Account account;
  final String accessToken;
  final String refreshToken;
}
