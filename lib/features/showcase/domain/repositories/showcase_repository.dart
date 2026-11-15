import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';

abstract class ShowcaseRepository {
  Future<Result<List<ShowcaseProject>>> getProjects();
  Future<Result<ShowcaseProject>> getProject(String id);
}
