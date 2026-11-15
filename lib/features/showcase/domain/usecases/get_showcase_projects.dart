import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/repositories/showcase_repository.dart';

class GetShowcaseProjects {
  const GetShowcaseProjects(this._repository);
  final ShowcaseRepository _repository;

  Future<Result<List<ShowcaseProject>>> call() => _repository.getProjects();
}
