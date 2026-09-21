import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/documents/data/datasources/documents_local_datasource.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';
import 'package:rak_customer/features/documents/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._datasource);
  final DocumentsLocalDatasource _datasource;

  @override
  Future<Result<List<ProjectDocument>>> getDocuments({
    required String accountId,
    required String projectId,
  }) async {
    try {
      return Success(
        await _datasource.listPublished(
          accountId: accountId,
          projectId: projectId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<AssetAccess>> requestAccess(String assetId) async {
    try {
      return Success(await _datasource.requestAccess(assetId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
