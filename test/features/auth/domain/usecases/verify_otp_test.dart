import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/core/domain/entities/session.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/auth/domain/usecases/verify_otp.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late VerifyOtp usecase;

  setUp(() {
    repository = _MockAuthRepository();
    usecase = VerifyOtp(repository);
  });

  test('rejects a code that is too short', () async {
    final result = await usecase(challengeId: 'ch', code: '12');
    expect(result.failureOrNull, isA<ValidationFailure>());
  });

  test('returns the session on a valid code', () async {
    const session = Session(
      account: Account(
        id: 'acc',
        phone: '+919876540001',
        displayName: 'Anjali Menon',
        hasProjects: true,
      ),
      accessToken: 'a',
      refreshToken: 'r',
    );
    when(
      () => repository.verifyOtp(challengeId: 'ch', code: '123456'),
    ).thenAnswer((_) async => const Success(session));

    final result = await usecase(challengeId: 'ch', code: '123456');
    expect(result.valueOrNull?.account.hasProjects, isTrue);
  });

  test('strips spaces from a formatted OTP before verifying', () async {
    const session = Session(
      account: Account(
        id: 'acc',
        phone: '+919876540001',
        displayName: 'Anjali Menon',
        hasProjects: true,
      ),
      accessToken: 'a',
      refreshToken: 'r',
    );
    when(
      () => repository.verifyOtp(challengeId: 'ch', code: '123456'),
    ).thenAnswer((_) async => const Success(session));

    final result = await usecase(challengeId: 'ch', code: '1  2  3  4  5  6');
    expect(result.valueOrNull?.account.hasProjects, isTrue);
  });
}
