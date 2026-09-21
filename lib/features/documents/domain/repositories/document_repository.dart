import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';

abstract class DocumentRepository {
  Future<Result<List<ProjectDocument>>> getDocuments({
    required String accountId,
    required String projectId,
  });

  Future<Result<AssetAccess>> requestAccess(String assetId);
}
