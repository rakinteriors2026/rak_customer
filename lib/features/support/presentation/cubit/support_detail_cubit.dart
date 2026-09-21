import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_query.dart';

sealed class SupportDetailState {
  const SupportDetailState();
}

class SupportDetailLoading extends SupportDetailState {
  const SupportDetailLoading();
}

class SupportDetailLoaded extends SupportDetailState {
  const SupportDetailLoaded(this.query);
  final SupportQuery query;
}

class SupportDetailError extends SupportDetailState {
  const SupportDetailError(this.message);
  final String message;
}

class SupportDetailCubit extends Cubit<SupportDetailState> {
  SupportDetailCubit({
    required GetSupportQuery getSupportQuery,
    required this.accountId,
    required this.queryId,
  }) : _getSupportQuery = getSupportQuery,
       super(const SupportDetailLoading());

  final GetSupportQuery _getSupportQuery;
  final String accountId;
  final String queryId;

  Future<void> load() async {
    emit(const SupportDetailLoading());
    final result = await _getSupportQuery(
      accountId: accountId,
      queryId: queryId,
    );
    result.fold(
      onSuccess: (query) => emit(SupportDetailLoaded(query)),
      onFailure: (failure) => emit(SupportDetailError(failure.message)),
    );
  }
}
