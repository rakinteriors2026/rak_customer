import 'package:rak_customer/core/domain/entities/session.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class VerifyOtp {
  const VerifyOtp(this._repository);
  final AuthRepository _repository;

  Future<Result<Session>> call({
    required String challengeId,
    required String code,
  }) {
    final digits = code.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) {
      return Future.value(
        const Err(ValidationFailure('Enter the code we sent you.')),
      );
    }
    return _repository.verifyOtp(challengeId: challengeId, code: digits);
  }
}
