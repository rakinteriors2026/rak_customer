import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/projects/data/datasources/project_local_datasource.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl(this._datasource);
  final ProjectLocalDatasource _datasource;

  @override
  Future<Result<PageResult<InteriorProject>>> getMyProjects({
    required String accountId,
    String? cursor,
  }) async {
    try {
      final items = await _datasource.listForAccount(accountId);
      return Success(PageResult(items: items));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<InteriorProject>> getProject({
    required String accountId,
    required String projectId,
  }) async {
    try {
      return Success(
        await _datasource.getOwned(accountId: accountId, projectId: projectId),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
