import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class DeleteAccount {
  const DeleteAccount(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call({
    required String challengeId,
    required String code,
    required String phone,
  }) {
    final digits = code.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 6) {
      return Future.value(
        const Err(
          ValidationFailure('Enter the 6-digit code sent to your mobile.'),
        ),
      );
    }
    return _repository.deleteAccount(
      challengeId: challengeId,
      code: digits,
      phone: phone,
    );
  }
}
