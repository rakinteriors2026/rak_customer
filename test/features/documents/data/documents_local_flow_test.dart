import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/datasources/asset_access_local_datasource.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/documents/data/datasources/documents_local_datasource.dart';
import 'package:rak_customer/features/documents/data/repositories/document_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late DocumentRepositoryImpl repository;
  var now = DateTime.utc(2026, 9, 8, 6, 30);

  setUp(() async {
    now = DateTime.utc(2026, 9, 8, 6, 30);
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = DocumentRepositoryImpl(
      DocumentsLocalDatasource(
        db: db,
        assetAccess: AssetAccessLocalDatasource(
          db: db,
          clock: Clock(now: () => now),
          accessTtl: const Duration(minutes: 2),
        ),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('lists published documents only, grouped-ready by type', () async {
    final result = await repository.getDocuments(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.alBarariId,
    );
    final docs = result.valueOrNull!;
    expect(docs.map((d) => d.id), [
      'doc_agreement',
      'doc_quote_v2',
      'doc_invoice',
    ]);
    expect(docs.any((d) => d.id == 'doc_draft'), isFalse);
    expect(docs.map((d) => d.type).toSet(), {
      'agreement',
      'quotation',
      'invoice',
    });
  });

  test('buyer-only account cannot read another client documents', () async {
    final result = await repository.getDocuments(
      accountId: SeedData.buyerAccountId,
      projectId: SeedData.alBarariId,
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test(
    'a project with no published documents is empty, not an error',
    () async {
      final result = await repository.getDocuments(
        accountId: SeedData.projectsAccountId,
        projectId: SeedData.difcId,
      );
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isEmpty);
    },
  );

  test('re-issues document access after the signed link expires', () async {
    final first = await repository.requestAccess('ast_doc_agreement');
    final firstUrl = first.valueOrNull!.signedUrl;

    now = now.add(const Duration(minutes: 3));
    final second = await repository.requestAccess('ast_doc_agreement');
    expect(second.valueOrNull!.signedUrl, isNot(firstUrl));
    expect(second.valueOrNull!.isExpiredAt(now), isFalse);
  });

  test('unpublished document assets are unavailable', () async {
    final draft = await repository.requestAccess('ast_doc_draft');
    expect(draft.failureOrNull, isA<NotFoundFailure>());
  });
}
