import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/auth/domain/usecases/delete_account.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';
import 'package:rak_customer/features/auth/presentation/cubit/confirm_account_deletion_cubit.dart';

class _MockRequestOtp extends Mock implements RequestOtp {}

class _MockDeleteAccount extends Mock implements DeleteAccount {}

void main() {
  late _MockRequestOtp requestOtp;
  late _MockDeleteAccount deleteAccount;
  late ConfirmAccountDeletionCubit cubit;

  final challenge = OtpChallenge(
    id: 'ch',
    phone: '+919876540001',
    expiresAt: DateTime.utc(2026, 9, 8, 7),
    resendAfter: DateTime.utc(2026, 9, 8, 6, 31),
  );

  setUp(() {
    requestOtp = _MockRequestOtp();
    deleteAccount = _MockDeleteAccount();
    cubit = ConfirmAccountDeletionCubit(
      phone: '+919876540001',
      requestOtp: requestOtp,
      deleteAccount: deleteAccount,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  test('loads a delete OTP and only submits a 6-digit code', () async {
    when(
      () => requestOtp(any(), purpose: any(named: 'purpose')),
    ).thenAnswer((_) async => Success(challenge));
    when(
      () => deleteAccount(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer((_) async => const Success(null));

    await cubit.start();
    final ready = cubit.state as ConfirmAccountDeletionReady;
    expect(ready.canSubmit, isFalse);

    cubit.updateCode('123');
    expect((cubit.state as ConfirmAccountDeletionReady).canSubmit, isFalse);
    await cubit.submit();
    verifyNever(
      () => deleteAccount(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
        phone: any(named: 'phone'),
      ),
    );

    cubit.updateCode('123456');
    expect((cubit.state as ConfirmAccountDeletionReady).canSubmit, isTrue);
    await cubit.submit();
    expect(cubit.state, isA<ConfirmAccountDeletionSuccess>());
    verify(
      () => deleteAccount(
        challengeId: 'ch',
        code: '123456',
        phone: '+919876540001',
      ),
    ).called(1);
  });

  test('keeps the code on a failed delete', () async {
    when(
      () => requestOtp(any(), purpose: any(named: 'purpose')),
    ).thenAnswer((_) async => Success(challenge));
    when(
      () => deleteAccount(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer(
      (_) async => const Err(
        ValidationFailure(
          'That code did not work. Request a new one and try again.',
        ),
      ),
    );

    await cubit.start();
    cubit.updateCode('000000');
    await cubit.submit();

    final ready = cubit.state as ConfirmAccountDeletionReady;
    expect(ready.code, '000000');
    expect(ready.submitting, isFalse);
    expect(ready.error, isNotNull);
  });
}
