import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_project.dart';

sealed class ProjectDetailState {
  const ProjectDetailState();
}

class ProjectDetailLoading extends ProjectDetailState {
  const ProjectDetailLoading();
}

class ProjectDetailLoaded extends ProjectDetailState {
  const ProjectDetailLoaded(this.project);
  final InteriorProject project;
}

class ProjectDetailError extends ProjectDetailState {
  const ProjectDetailError(this.message, {this.accessDenied = false});
  final String message;
  final bool accessDenied;
}

class ProjectDetailCubit extends Cubit<ProjectDetailState> {
  ProjectDetailCubit({required GetProject getProject})
    : _getProject = getProject,
      super(const ProjectDetailLoading());

  final GetProject _getProject;

  Future<void> load({
    required String accountId,
    required String projectId,
  }) async {
    emit(const ProjectDetailLoading());
    final result = await _getProject(
      accountId: accountId,
      projectId: projectId,
    );
    result.fold(
      onSuccess: (project) => emit(ProjectDetailLoaded(project)),
      onFailure: (failure) =>
          emit(ProjectDetailError(failure.message, accessDenied: true)),
    );
  }
}
