import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';
import 'package:rak_customer/features/documents/domain/repositories/document_repository.dart';

class GetProjectDocuments {
  const GetProjectDocuments(this._repository);
  final DocumentRepository _repository;

  Future<Result<List<ProjectDocument>>> call({
    required String accountId,
    required String projectId,
  }) {
    return _repository.getDocuments(accountId: accountId, projectId: projectId);
  }
}
