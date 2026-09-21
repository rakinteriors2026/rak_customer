import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';

abstract class ProjectRepository {
  Future<Result<PageResult<InteriorProject>>> getMyProjects({
    required String accountId,
    String? cursor,
  });

  Future<Result<InteriorProject>> getProject({
    required String accountId,
    required String projectId,
  });
}
