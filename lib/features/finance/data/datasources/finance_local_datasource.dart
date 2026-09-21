import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';

class FinanceLocalDatasource {
  FinanceLocalDatasource(this._db);
  final AppDatabase _db;

  Future<ProjectFinance?> getOwned({
    required String accountId,
    required String projectId,
  }) async {
    final project =
        await (_db.select(_db.projects)..where(
              (t) => t.id.equals(projectId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (project == null) {
      throw const NotFoundFailure('This project is not available.');
    }

    final balance = await (_db.select(
      _db.projectBalances,
    )..where((t) => t.projectId.equals(projectId))).getSingleOrNull();
    if (balance == null) return null;

    final entries =
        await (_db.select(_db.ledgerEntries)
              ..where((t) => t.projectId.equals(projectId))
              ..orderBy([(t) => OrderingTerm.asc(t.sortCursor)]))
            .get();
    final dues =
        await (_db.select(_db.dueScheduleItems)
              ..where((t) => t.projectId.equals(projectId))
              ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
            .get();

    Money money(int minor) =>
        Money(minorUnits: minor, currency: balance.currency);

    return ProjectFinance(
      projectId: projectId,
      currency: balance.currency,
      asOf: balance.asOf,
      totalContract: money(balance.totalContractMinor),
      approvedVariations: money(balance.approvedVariationsMinor),
      netReceived: money(balance.netReceivedMinor),
      outstandingTotal: money(balance.outstandingTotalMinor),
      amountCurrentlyDue: money(balance.amountCurrentlyDueMinor),
      creditOverpayment: money(balance.creditOverpaymentMinor),
      entries: entries
          .map(
            (row) => LedgerEntry(
              id: row.id,
              description: row.description,
              state: row.state,
              amount: money(row.amountMinor),
              postedAt: row.postedAt,
            ),
          )
          .toList(),
      dueSchedule: dues
          .map(
            (row) => DueScheduleItem(
              id: row.id,
              label: row.label,
              amount: money(row.amountMinor),
              dueAt: row.dueAt,
            ),
          )
          .toList(),
    );
  }
}
