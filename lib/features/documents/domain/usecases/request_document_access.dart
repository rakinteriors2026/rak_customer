import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/documents/domain/repositories/document_repository.dart';

class RequestDocumentAccess {
  const RequestDocumentAccess(this._repository);
  final DocumentRepository _repository;

  Future<Result<AssetAccess>> call(String assetId) {
    return _repository.requestAccess(assetId);
  }
}
