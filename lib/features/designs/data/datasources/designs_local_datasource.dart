import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/datasources/asset_access_local_datasource.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';

class DesignsLocalDatasource {
  DesignsLocalDatasource({
    required AppDatabase db,
    required AssetAccessLocalDatasource assetAccess,
  }) : _db = db,
       _assetAccess = assetAccess;

  final AppDatabase _db;
  final AssetAccessLocalDatasource _assetAccess;

  Future<List<ApprovedDesign>> listApprovedPublished({
    required String accountId,
    required String projectId,
  }) async {
    final owned =
        await (_db.select(_db.projects)..where(
              (t) => t.id.equals(projectId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (owned == null) {
      throw const NotFoundFailure('This project is not available.');
    }

    final rows =
        await (_db.select(_db.designs)
              ..where(
                (t) =>
                    t.projectId.equals(projectId) &
                    t.approved.equals(true) &
                    t.published.equals(true),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
            .get();

    final designs = <ApprovedDesign>[];
    for (final row in rows) {
      final links =
          await (_db.select(_db.designAssets)
                ..where((t) => t.designId.equals(row.id))
                ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
              .get();
      designs.add(
        ApprovedDesign(
          id: row.id,
          projectId: row.projectId,
          title: row.title,
          versionLabel: row.versionLabel,
          assetIds: links.map((link) => link.assetId).toList(),
        ),
      );
    }
    return designs;
  }

  Future<AssetAccess> requestAccess(String assetId) {
    return _assetAccess.requestAccess(assetId);
  }
}
