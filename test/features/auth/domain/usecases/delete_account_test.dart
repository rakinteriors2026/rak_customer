import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/auth/domain/usecases/delete_account.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late DeleteAccount usecase;

  setUp(() {
    repository = _MockAuthRepository();
    usecase = DeleteAccount(repository);
  });

  test('rejects a code that is not 6 digits', () async {
    final result = await usecase(
      challengeId: 'ch',
      code: '123',
      phone: '+919876540001',
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(
      () => repository.deleteAccount(
        challengeId: any(named: 'challengeId'),
        code: any(named: 'code'),
        phone: any(named: 'phone'),
      ),
    );
  });

  test('strips spaces and deletes when the code is 6 digits', () async {
    when(
      () => repository.deleteAccount(
        challengeId: 'ch',
        code: '123456',
        phone: '+919876540001',
      ),
    ).thenAnswer((_) async => const Success(null));

    final result = await usecase(
      challengeId: 'ch',
      code: '1  2  3  4  5  6',
      phone: '+919876540001',
    );

    expect(result.isSuccess, isTrue);
  });
}
