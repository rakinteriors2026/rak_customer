import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';

class SupportLocalDatasource {
  SupportLocalDatasource({required AppDatabase db, required Clock clock})
    : _db = db,
      _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Future<List<SupportQuery>> listOwned(String accountId) async {
    final rows =
        await (_db.select(_db.supportQueries)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return rows.map(_toQuery).toList();
  }

  Future<SupportQuery> getOwned({
    required String accountId,
    required String queryId,
  }) async {
    final row =
        await (_db.select(_db.supportQueries)..where(
              (t) => t.id.equals(queryId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw const NotFoundFailure('This ticket is not available.');
    }
    return _toQuery(row);
  }

  Future<SupportContexts> listContexts(String accountId) async {
    final projects =
        await (_db.select(_db.projects)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => OrderingTerm.desc(t.sortCursor)]))
            .get();
    final orders =
        await (_db.select(_db.shopOrders)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return SupportContexts(
      options: [
        for (final project in projects)
          SupportContextOption.project(id: project.id, label: project.name),
        for (final order in orders)
          SupportContextOption.order(
            id: order.id,
            label: 'Order ${order.id}',
          ),
      ],
    );
  }

  Future<SupportQuery> create({
    required String accountId,
    required String subject,
    required String message,
    String? projectId,
    String? orderId,
  }) async {
    final trimmedSubject = subject.trim();
    final trimmedMessage = message.trim();
    if (trimmedSubject.isEmpty || trimmedMessage.isEmpty) {
      throw const ValidationFailure('Add a subject and a message.');
    }

    final hasProject = projectId != null && projectId.isNotEmpty;
    final hasOrder = orderId != null && orderId.isNotEmpty;
    if (hasProject == hasOrder) {
      throw const ValidationFailure('Choose a project or an order, not both.');
    }

    if (hasProject) {
      final owned =
          await (_db.select(_db.projects)..where(
                (t) => t.id.equals(projectId) & t.accountId.equals(accountId),
              ))
              .getSingleOrNull();
      if (owned == null) {
        throw const NotFoundFailure('This project is not available.');
      }
    }

    if (hasOrder) {
      final owned =
          await (_db.select(_db.shopOrders)..where(
                (t) => t.id.equals(orderId) & t.accountId.equals(accountId),
              ))
              .getSingleOrNull();
      if (owned == null) {
        throw const NotFoundFailure('This order is not available.');
      }
    }

    final now = _clock.now().toUtc();
    final id = 'qry_${now.microsecondsSinceEpoch}';
    await _db
        .into(_db.supportQueries)
        .insert(
          SupportQueriesCompanion.insert(
            id: id,
            accountId: accountId,
            projectId: Value(hasProject ? projectId : null),
            orderId: Value(hasOrder ? orderId : null),
            subject: trimmedSubject,
            message: trimmedMessage,
            status: 'open',
            queueLabel: const Value('Customer support'),
            createdAt: now,
          ),
        );
    return getOwned(accountId: accountId, queryId: id);
  }

  Future<SupportQuery> updateStatus({
    required String accountId,
    required String queryId,
    required String status,
  }) async {
    if (status != 'replied' && status != 'closed') {
      throw const ValidationFailure('That question status is not available.');
    }
    final existing = await getOwned(accountId: accountId, queryId: queryId);
    if (existing.status == 'closed') {
      throw const ValidationFailure('This question is closed.');
    }
    await (_db.update(_db.supportQueries)..where((t) => t.id.equals(queryId)))
        .write(SupportQueriesCompanion(status: Value(status)));
    return getOwned(accountId: accountId, queryId: queryId);
  }

  SupportQuery _toQuery(SupportQueryRow row) {
    return SupportQuery(
      id: row.id,
      accountId: row.accountId,
      projectId: row.projectId,
      orderId: row.orderId,
      subject: row.subject,
      message: row.message,
      status: row.status,
      queueLabel: row.queueLabel,
      createdAt: row.createdAt,
    );
  }
}
