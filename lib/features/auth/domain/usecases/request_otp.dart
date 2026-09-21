import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class RequestOtp {
  const RequestOtp(this._repository);
  final AuthRepository _repository;

  static final phonePattern = RegExp(r'^\+[1-9]\d{7,14}$');

  Future<Result<OtpChallenge>> call(
    String rawPhone, {
    String purpose = 'login',
  }) {
    final phone = rawPhone.replaceAll(RegExp(r'\s+'), '');
    if (!phonePattern.hasMatch(phone)) {
      return Future.value(
        const Err(
          ValidationFailure(
            'Enter a phone number with country code, like +91 98765 43210.',
          ),
        ),
      );
    }
    return _repository.requestOtp(phone: phone, purpose: purpose);
  }
}
