import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_queries.dart';

sealed class SupportListState {
  const SupportListState();
}

class SupportListLoading extends SupportListState {
  const SupportListLoading();
}

class SupportListEmpty extends SupportListState {
  const SupportListEmpty();
}

class SupportListLoaded extends SupportListState {
  const SupportListLoaded(this.queries);
  final List<SupportQuery> queries;
}

class SupportListError extends SupportListState {
  const SupportListError(this.message);
  final String message;
}

class SupportListCubit extends Cubit<SupportListState> {
  SupportListCubit({
    required GetSupportQueries getSupportQueries,
    required this.accountId,
  }) : _getSupportQueries = getSupportQueries,
       super(const SupportListLoading());

  final GetSupportQueries _getSupportQueries;
  final String accountId;

  Future<void> load() async {
    emit(const SupportListLoading());
    final result = await _getSupportQueries(accountId);
    result.fold(
      onSuccess: (queries) {
        if (queries.isEmpty) {
          emit(const SupportListEmpty());
          return;
        }
        emit(SupportListLoaded(queries));
      },
      onFailure: (failure) => emit(SupportListError(failure.message)),
    );
  }
}
