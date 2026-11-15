import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/usecases/get_showcase_project.dart';

sealed class ShowcaseDetailState {
  const ShowcaseDetailState();
}

class ShowcaseDetailLoading extends ShowcaseDetailState {
  const ShowcaseDetailLoading();
}

class ShowcaseDetailLoaded extends ShowcaseDetailState {
  const ShowcaseDetailLoaded(this.project);
  final ShowcaseProject project;
}

class ShowcaseDetailError extends ShowcaseDetailState {
  const ShowcaseDetailError(this.message);
  final String message;
}

class ShowcaseDetailCubit extends Cubit<ShowcaseDetailState> {
  ShowcaseDetailCubit({required GetShowcaseProject getShowcaseProject})
    : _getShowcaseProject = getShowcaseProject,
      super(const ShowcaseDetailLoading());

  final GetShowcaseProject _getShowcaseProject;

  Future<void> load(String id) async {
    emit(const ShowcaseDetailLoading());
    final result = await _getShowcaseProject(id);
    emit(
      result.fold(
        onSuccess: ShowcaseDetailLoaded.new,
        onFailure: (failure) => ShowcaseDetailError(failure.message),
      ),
    );
  }
}
