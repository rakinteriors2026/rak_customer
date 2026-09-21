import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';

class _MockSupportRepository extends Mock implements SupportRepository {}

void main() {
  late _MockSupportRepository repository;
  late CreateSupportQuery usecase;

  setUp(() {
    repository = _MockSupportRepository();
    usecase = CreateSupportQuery(repository);
  });

  test('creates a project-context query', () async {
    final query = SupportQuery(
      id: 'qry_1',
      accountId: 'acc',
      projectId: 'prj',
      subject: 'Joinery',
      message: 'When?',
      status: 'open',
      createdAt: DateTime.utc(2026, 9, 8),
    );
    when(
      () => repository.createQuery(
        accountId: 'acc',
        subject: 'Joinery',
        message: 'When?',
        projectId: 'prj',
        orderId: null,
      ),
    ).thenAnswer((_) async => Success(query));

    final result = await usecase(
      accountId: 'acc',
      subject: 'Joinery',
      message: 'When?',
      projectId: 'prj',
    );
    expect(result.valueOrNull?.projectId, 'prj');
    expect(result.valueOrNull?.orderId, isNull);
  });

  test('surfaces validation when context is invalid', () async {
    when(
      () => repository.createQuery(
        accountId: 'acc',
        subject: 'Joinery',
        message: 'When?',
        projectId: 'prj',
        orderId: 'ord',
      ),
    ).thenAnswer((_) async => const Err(ValidationFailure()));

    final result = await usecase(
      accountId: 'acc',
      subject: 'Joinery',
      message: 'When?',
      projectId: 'prj',
      orderId: 'ord',
    );
    expect(result.failureOrNull, isA<ValidationFailure>());
  });
}
