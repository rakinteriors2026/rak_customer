import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late RequestOtp usecase;

  setUp(() {
    repository = _MockAuthRepository();
    usecase = RequestOtp(repository);
  });

  test('rejects a phone number without a country code', () async {
    final result = await usecase('0501234567');
    expect(result, isA<Err<OtpChallenge>>());
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(
      () => repository.requestOtp(
        phone: any(named: 'phone'),
        purpose: any(named: 'purpose'),
      ),
    );
  });

  test('requests an OTP for a valid E.164 number', () async {
    final challenge = OtpChallenge(
      id: 'ch1',
      phone: '+919876540001',
      expiresAt: DateTime.utc(2026, 9, 8, 7),
      resendAfter: DateTime.utc(2026, 9, 8, 6, 31),
    );
    when(
      () => repository.requestOtp(phone: '+919876540001', purpose: 'login'),
    ).thenAnswer((_) async => Success(challenge));

    final result = await usecase('+91 9876540001');

    expect(result.valueOrNull, challenge);
  });

  test('requests an OTP with an explicit purpose', () async {
    final challenge = OtpChallenge(
      id: 'ch2',
      phone: '+919876540001',
      expiresAt: DateTime.utc(2026, 9, 8, 7),
      resendAfter: DateTime.utc(2026, 9, 8, 6, 31),
    );
    when(
      () => repository.requestOtp(
        phone: '+919876540001',
        purpose: 'delete_account',
      ),
    ).thenAnswer((_) async => Success(challenge));

    final result = await usecase('+919876540001', purpose: 'delete_account');

    expect(result.valueOrNull, challenge);
  });
}
