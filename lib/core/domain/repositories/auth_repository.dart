import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/entities/session.dart';
import 'package:rak_customer/core/domain/result.dart';

abstract class AuthRepository {
  Future<Result<OtpChallenge>> requestOtp({
    required String phone,
    required String purpose,
  });

  Future<Result<Session>> verifyOtp({
    required String challengeId,
    required String code,
  });

  Future<Result<Session?>> currentSession();

  Future<Result<void>> logout();

  Future<Result<void>> deleteAccount({
    required String challengeId,
    required String code,
    required String phone,
  });
}
