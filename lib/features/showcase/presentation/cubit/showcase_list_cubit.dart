import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/usecases/get_showcase_projects.dart';

sealed class ShowcaseListState {
  const ShowcaseListState();
}

class ShowcaseListLoading extends ShowcaseListState {
  const ShowcaseListLoading();
}

class ShowcaseListLoaded extends ShowcaseListState {
  const ShowcaseListLoaded(this.projects);
  final List<ShowcaseProject> projects;
}

class ShowcaseListError extends ShowcaseListState {
  const ShowcaseListError(this.message);
  final String message;
}

class ShowcaseListCubit extends Cubit<ShowcaseListState> {
  ShowcaseListCubit({required GetShowcaseProjects getShowcaseProjects})
    : _getShowcaseProjects = getShowcaseProjects,
      super(const ShowcaseListLoading());

  final GetShowcaseProjects _getShowcaseProjects;

  Future<void> load() async {
    emit(const ShowcaseListLoading());
    final result = await _getShowcaseProjects();
    emit(
      result.fold(
        onSuccess: ShowcaseListLoaded.new,
        onFailure: (failure) => ShowcaseListError(failure.message),
      ),
    );
  }
}
