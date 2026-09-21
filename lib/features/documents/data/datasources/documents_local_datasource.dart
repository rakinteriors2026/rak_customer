import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/datasources/asset_access_local_datasource.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';

class DocumentsLocalDatasource {
  DocumentsLocalDatasource({
    required AppDatabase db,
    required AssetAccessLocalDatasource assetAccess,
  }) : _db = db,
       _assetAccess = assetAccess;

  final AppDatabase _db;
  final AssetAccessLocalDatasource _assetAccess;

  Future<List<ProjectDocument>> listPublished({
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
        await (_db.select(_db.projectDocuments)
              ..where(
                (t) => t.projectId.equals(projectId) & t.published.equals(true),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();

    return rows
        .map(
          (row) => ProjectDocument(
            id: row.id,
            projectId: row.projectId,
            type: row.type,
            title: row.title,
            assetId: row.assetId,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  Future<AssetAccess> requestAccess(String assetId) {
    return _assetAccess.requestAccess(assetId);
  }
}
