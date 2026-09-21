import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/finance/data/datasources/finance_local_datasource.dart';
import 'package:rak_customer/features/finance/data/repositories/finance_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late FinanceRepositoryImpl repository;

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = FinanceRepositoryImpl(FinanceLocalDatasource(db));
  });

  tearDown(() async {
    await db.close();
  });

  test('returns seeded totals exactly, without deriving outstanding', () async {
    final result = await repository.getProjectFinance(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.alBarariId,
    );
    final finance = result.valueOrNull!;
    expect(finance.totalContract.minorUnits, SeedData.totalContractMinor);
    expect(
      finance.approvedVariations.minorUnits,
      SeedData.approvedVariationsMinor,
    );
    expect(finance.netReceived.minorUnits, SeedData.netReceivedMinor);
    expect(finance.outstandingTotal.minorUnits, SeedData.outstandingTotalMinor);
    expect(
      finance.amountCurrentlyDue.minorUnits,
      SeedData.amountCurrentlyDueMinor,
    );
    expect(
      finance.creditOverpayment.minorUnits,
      SeedData.creditOverpaymentMinor,
    );
    expect(
      finance.outstandingTotal.minorUnits,
      isNot(
        finance.totalContract.minorUnits +
            finance.approvedVariations.minorUnits -
            finance.netReceived.minorUnits,
      ),
    );
  });

  test('buyer-only account cannot read another client ledger', () async {
    final result = await repository.getProjectFinance(
      accountId: SeedData.buyerAccountId,
      projectId: SeedData.alBarariId,
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test('a project with no published ledger is empty, not an error', () async {
    final result = await repository.getProjectFinance(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.difcId,
    );
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, isNull);
  });
}
