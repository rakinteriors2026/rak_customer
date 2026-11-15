import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/repositories/showcase_repository.dart';

class GetShowcaseProject {
  const GetShowcaseProject(this._repository);
  final ShowcaseRepository _repository;

  Future<Result<ShowcaseProject>> call(String id) {
    if (id.isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Missing showcase id.')),
      );
    }
    return _repository.getProject(id);
  }
}
