import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/domain/repositories/finance_repository.dart';
import 'package:rak_customer/features/finance/domain/usecases/get_project_finance.dart';

class _MockFinanceRepository extends Mock implements FinanceRepository {}

void main() {
  late _MockFinanceRepository repository;
  late GetProjectFinance usecase;

  setUp(() {
    repository = _MockFinanceRepository();
    usecase = GetProjectFinance(repository);
  });

  test('returns repository totals without changing them', () async {
    const outstanding = Money(minorUnits: 77700000, currency: 'INR');
    final finance = ProjectFinance(
      projectId: 'prj',
      currency: 'INR',
      asOf: DateTime.utc(2026, 9, 6),
      totalContract: const Money(minorUnits: 185000000, currency: 'INR'),
      approvedVariations: const Money(minorUnits: 12000000, currency: 'INR'),
      netReceived: const Money(minorUnits: 98000000, currency: 'INR'),
      outstandingTotal: outstanding,
      amountCurrentlyDue: const Money(minorUnits: 25000000, currency: 'INR'),
      creditOverpayment: const Money(minorUnits: 1500000, currency: 'INR'),
      entries: const [],
      dueSchedule: const [],
    );
    when(
      () => repository.getProjectFinance(accountId: 'acc', projectId: 'prj'),
    ).thenAnswer((_) async => Success(finance));

    final result = await usecase(accountId: 'acc', projectId: 'prj');
    expect(result.valueOrNull?.outstandingTotal, outstanding);
  });

  test('surfaces not-found when the project is not owned', () async {
    when(
      () => repository.getProjectFinance(
        accountId: 'acc_buyer',
        projectId: 'prj',
      ),
    ).thenAnswer((_) async => const Err(NotFoundFailure()));

    final result = await usecase(accountId: 'acc_buyer', projectId: 'prj');
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
