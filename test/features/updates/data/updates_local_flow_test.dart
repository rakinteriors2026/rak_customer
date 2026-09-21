import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/updates/data/datasources/updates_local_datasource.dart';
import 'package:rak_customer/features/updates/data/repositories/updates_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late UpdatesRepositoryImpl repository;
  var now = DateTime.utc(2026, 9, 8, 6, 30);

  setUp(() async {
    now = DateTime.utc(2026, 9, 8, 6, 30);
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = UpdatesRepositoryImpl(
      UpdatesLocalDatasource(
        db: db,
        clock: Clock(now: () => now),
        accessTtl: const Duration(minutes: 2),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('lists only published updates newest first and paginates', () async {
    final first = await repository.getProjectUpdates(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.alBarariId,
      pageSize: 2,
    );
    expect(first.valueOrNull?.items.map((u) => u.id), [
      'upd_joinery',
      'upd_note',
    ]);
    expect(first.valueOrNull?.items.any((u) => u.id == 'upd_draft'), isFalse);
    expect(first.valueOrNull?.nextCursor, '008');

    final second = await repository.getProjectUpdates(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.alBarariId,
      cursor: first.valueOrNull!.nextCursor,
      pageSize: 2,
    );
    expect(second.valueOrNull?.items.map((u) => u.id), ['upd_kitchen']);
    expect(second.valueOrNull?.hasMore, isFalse);
  });

  test('buyer-only account cannot read another client project feed', () async {
    final result = await repository.getProjectUpdates(
      accountId: SeedData.buyerAccountId,
      projectId: SeedData.alBarariId,
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test('empty published feed is a success, not an error', () async {
    final result = await repository.getProjectUpdates(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.difcId,
    );
    expect(result.valueOrNull?.isEmpty, isTrue);
  });

  test('re-issues access after the signed link expires', () async {
    final first = await repository.requestAssetAccess('ast_joinery_1');
    final firstUrl = first.valueOrNull!.signedUrl;

    now = now.add(const Duration(minutes: 3));
    final second = await repository.requestAssetAccess('ast_joinery_1');
    expect(second.valueOrNull!.signedUrl, isNot(firstUrl));
    expect(second.valueOrNull!.isExpiredAt(now), isFalse);
  });

  test('withdrawn and draft assets are unavailable', () async {
    final withdrawn = await repository.requestAssetAccess(
      'ast_kitchen_withdrawn',
    );
    expect(withdrawn.failureOrNull, isA<NotFoundFailure>());

    final draft = await repository.requestAssetAccess('ast_draft_internal');
    expect(draft.failureOrNull, isA<NotFoundFailure>());
  });
}
