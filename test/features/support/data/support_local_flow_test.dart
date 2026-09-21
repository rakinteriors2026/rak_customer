import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/support/data/datasources/support_local_datasource.dart';
import 'package:rak_customer/features/support/data/repositories/support_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late SupportRepositoryImpl repository;

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = SupportRepositoryImpl(
      SupportLocalDatasource(
        db: db,
        clock: Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30)),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('creates a project-context query for the owner', () async {
    final result = await repository.createQuery(
      accountId: SeedData.projectsAccountId,
      subject: 'Site access',
      message: 'Please confirm the next visit window.',
      projectId: SeedData.alBarariId,
    );
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.projectId, SeedData.alBarariId);
    expect(result.valueOrNull?.orderId, isNull);
    expect(result.valueOrNull?.queueLabel, 'Customer support');
  });

  test('creates an order-context query', () async {
    final result = await repository.createQuery(
      accountId: SeedData.buyerAccountId,
      subject: 'Delivery',
      message: 'Need a delivery update.',
      orderId: 'ord_demo',
    );
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.orderId, 'ord_demo');
    expect(result.valueOrNull?.projectId, isNull);
  });

  test('rejects both project and order, or neither', () async {
    final both = await repository.createQuery(
      accountId: SeedData.projectsAccountId,
      subject: 'Both',
      message: 'Invalid',
      projectId: SeedData.alBarariId,
      orderId: 'ord_demo',
    );
    expect(both.failureOrNull, isA<ValidationFailure>());

    final neither = await repository.createQuery(
      accountId: SeedData.projectsAccountId,
      subject: 'Neither',
      message: 'Invalid',
    );
    expect(neither.failureOrNull, isA<ValidationFailure>());
  });

  test('foreign ticket id is not found, not another users ticket', () async {
    final result = await repository.getQuery(
      accountId: SeedData.projectsAccountId,
      queryId: SeedData.foreignTicketId,
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
    expect(result.valueOrNull, isNull);
  });

  test('lists only the callers tickets', () async {
    final result = await repository.getQueries(SeedData.projectsAccountId);
    expect(result.valueOrNull?.map((q) => q.id), [SeedData.ticketAlBarariId]);
  });

  test('empty ticket list is a success', () async {
    final result = await repository.getQueries('acc_nobody');
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, isEmpty);
  });

  test('buyer without a project or order has no create contexts', () async {
    final result = await repository.getContexts(SeedData.buyerAccountId);
    expect(result.valueOrNull?.isEmpty, isTrue);
  });
}
