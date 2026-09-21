import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/domain/usecases/get_project_updates.dart';

sealed class UpdatesState {
  const UpdatesState();
}

class UpdatesLoading extends UpdatesState {
  const UpdatesLoading();
}

class UpdatesEmpty extends UpdatesState {
  const UpdatesEmpty();
}

class UpdatesLoaded extends UpdatesState {
  const UpdatesLoaded({
    required this.updates,
    this.nextCursor,
    this.loadingMore = false,
  });

  final List<SiteUpdate> updates;
  final String? nextCursor;
  final bool loadingMore;

  bool get hasMore => nextCursor != null;
}

class UpdatesError extends UpdatesState {
  const UpdatesError(this.message);
  final String message;
}

class UpdatesCubit extends Cubit<UpdatesState> {
  UpdatesCubit({
    required GetProjectUpdates getProjectUpdates,
    required this.accountId,
    required this.projectId,
    this.pageSize = 20,
  }) : _getProjectUpdates = getProjectUpdates,
       super(const UpdatesLoading());

  final GetProjectUpdates _getProjectUpdates;
  final String accountId;
  final String projectId;
  final int pageSize;

  Future<void> load() async {
    emit(const UpdatesLoading());
    final result = await _getProjectUpdates(
      accountId: accountId,
      projectId: projectId,
      pageSize: pageSize,
    );
    result.fold(
      onSuccess: (page) {
        emit(
          page.isEmpty
              ? const UpdatesEmpty()
              : UpdatesLoaded(updates: page.items, nextCursor: page.nextCursor),
        );
      },
      onFailure: (failure) => emit(UpdatesError(failure.message)),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! UpdatesLoaded || !current.hasMore || current.loadingMore) {
      return;
    }
    emit(
      UpdatesLoaded(
        updates: current.updates,
        nextCursor: current.nextCursor,
        loadingMore: true,
      ),
    );
    final result = await _getProjectUpdates(
      accountId: accountId,
      projectId: projectId,
      cursor: current.nextCursor,
      pageSize: pageSize,
    );
    result.fold(
      onSuccess: (page) {
        emit(
          UpdatesLoaded(
            updates: [...current.updates, ...page.items],
            nextCursor: page.nextCursor,
          ),
        );
      },
      onFailure: (failure) => emit(UpdatesError(failure.message)),
    );
  }
}
