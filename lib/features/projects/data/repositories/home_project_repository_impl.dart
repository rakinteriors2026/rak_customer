import 'package:rak_customer/core/domain/entities/home_project_progress.dart';
import 'package:rak_customer/core/domain/repositories/home_project_repository.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_my_projects.dart';

class HomeProjectRepositoryImpl implements HomeProjectRepository {
  HomeProjectRepositoryImpl(this._projects);

  final GetMyProjects _projects;

  @override
  Future<List<HomeProjectProgress>> progressFor(String accountId) async {
    final result = await _projects(accountId: accountId);
    final page = result.valueOrNull;
    if (page == null) return const [];
    return [
      for (final project in page.items)
        HomeProjectProgress(
          id: project.id,
          name: project.name,
          siteLabel: project.siteLabel,
          phaseLabel: project.phaseLabel,
          progressPercent: project.progressPercent,
        ),
    ];
  }
}
