import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/repositories/project_repository.dart';

class GetMyProjects {
  const GetMyProjects(this._repository);
  final ProjectRepository _repository;

  Future<Result<PageResult<InteriorProject>>> call({
    required String accountId,
    String? cursor,
  }) {
    return _repository.getMyProjects(accountId: accountId, cursor: cursor);
  }
}
