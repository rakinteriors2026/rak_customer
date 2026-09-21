import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/repositories/project_repository.dart';

class GetProject {
  const GetProject(this._repository);
  final ProjectRepository _repository;

  Future<Result<InteriorProject>> call({
    required String accountId,
    required String projectId,
  }) {
    return _repository.getProject(accountId: accountId, projectId: projectId);
  }
}
