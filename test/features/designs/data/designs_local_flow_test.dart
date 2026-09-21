import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/datasources/asset_access_local_datasource.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/designs/data/datasources/designs_local_datasource.dart';
import 'package:rak_customer/features/designs/data/repositories/design_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late DesignRepositoryImpl repository;

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = DesignRepositoryImpl(
      DesignsLocalDatasource(
        db: db,
        assetAccess: AssetAccessLocalDatasource(db: db, clock: const Clock()),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('lists only approved and published designs', () async {
    final result = await repository.getDesigns(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.alBarariId,
    );
    final designs = result.valueOrNull!;
    expect(designs.map((d) => d.id), ['dsn_living', 'dsn_kitchen']);
    expect(designs.any((d) => d.id == 'dsn_option_b'), isFalse);
    expect(designs.any((d) => d.id == 'dsn_internal'), isFalse);
  });

  test('buyer-only account cannot read another client designs', () async {
    final result = await repository.getDesigns(
      accountId: SeedData.buyerAccountId,
      projectId: SeedData.alBarariId,
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  test('a project with no approved designs is empty, not an error', () async {
    final result = await repository.getDesigns(
      accountId: SeedData.projectsAccountId,
      projectId: SeedData.difcId,
    );
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, isEmpty);
  });
}
