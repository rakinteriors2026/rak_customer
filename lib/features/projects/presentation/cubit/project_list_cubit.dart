import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_my_projects.dart';

sealed class ProjectListState {
  const ProjectListState();
}

class ProjectListLoading extends ProjectListState {
  const ProjectListLoading();
}

class ProjectListEmpty extends ProjectListState {
  const ProjectListEmpty();
}

class ProjectListLoaded extends ProjectListState {
  const ProjectListLoaded(this.projects);
  final List<InteriorProject> projects;
}

class ProjectListError extends ProjectListState {
  const ProjectListError(this.message);
  final String message;
}

class ProjectListCubit extends Cubit<ProjectListState> {
  ProjectListCubit({required GetMyProjects getMyProjects})
    : _getMyProjects = getMyProjects,
      super(const ProjectListLoading());

  final GetMyProjects _getMyProjects;

  Future<void> load(String accountId) async {
    emit(const ProjectListLoading());
    final result = await _getMyProjects(accountId: accountId);
    result.fold(
      onSuccess: (page) {
        emit(
          page.isEmpty
              ? const ProjectListEmpty()
              : ProjectListLoaded(page.items),
        );
      },
      onFailure: (failure) => emit(ProjectListError(failure.message)),
    );
  }
}
