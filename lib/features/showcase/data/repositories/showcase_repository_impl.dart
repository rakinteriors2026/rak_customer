import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/showcase/data/datasources/showcase_local_datasource.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/repositories/showcase_repository.dart';

class ShowcaseRepositoryImpl implements ShowcaseRepository {
  ShowcaseRepositoryImpl(this._datasource);
  final ShowcaseLocalDatasource _datasource;

  @override
  Future<Result<List<ShowcaseProject>>> getProjects() async {
    try {
      return Success(_datasource.projects());
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<ShowcaseProject>> getProject(String id) async {
    try {
      return Success(_datasource.project(id));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
