import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_contexts.dart';

sealed class CreateQueryState {
  const CreateQueryState();
}

class CreateQueryLoading extends CreateQueryState {
  const CreateQueryLoading();
}

class CreateQueryNoContext extends CreateQueryState {
  const CreateQueryNoContext();
}

class CreateQueryReady extends CreateQueryState {
  const CreateQueryReady({
    required this.contexts,
    this.selected,
    this.submitting = false,
    this.errorMessage,
  });

  final SupportContexts contexts;
  final SupportContextOption? selected;
  final bool submitting;
  final String? errorMessage;

  CreateQueryReady copyWith({
    SupportContextOption? selected,
    bool? submitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CreateQueryReady(
      contexts: contexts,
      selected: selected ?? this.selected,
      submitting: submitting ?? this.submitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CreateQuerySuccess extends CreateQueryState {
  const CreateQuerySuccess(this.query);
  final SupportQuery query;
}

class CreateQueryError extends CreateQueryState {
  const CreateQueryError(this.message);
  final String message;
}

class CreateQueryCubit extends Cubit<CreateQueryState> {
  CreateQueryCubit({
    required GetSupportContexts getSupportContexts,
    required CreateSupportQuery createSupportQuery,
    required this.accountId,
    this.prefilledProjectId,
    this.prefilledOrderId,
  }) : _getSupportContexts = getSupportContexts,
       _createSupportQuery = createSupportQuery,
       super(const CreateQueryLoading());

  final GetSupportContexts _getSupportContexts;
  final CreateSupportQuery _createSupportQuery;
  final String accountId;
  final String? prefilledProjectId;
  final String? prefilledOrderId;

  Future<void> load() async {
    emit(const CreateQueryLoading());
    final result = await _getSupportContexts(accountId);
    result.fold(
      onSuccess: (contexts) {
        if (contexts.isEmpty) {
          emit(const CreateQueryNoContext());
          return;
        }
        SupportContextOption? selected;
        if (prefilledProjectId != null) {
          selected = contexts.options
              .where(
                (option) =>
                    option.kind == SupportContextKind.project &&
                    option.id == prefilledProjectId,
              )
              .firstOrNull;
        } else if (prefilledOrderId != null) {
          selected = contexts.options
              .where(
                (option) =>
                    option.kind == SupportContextKind.order &&
                    option.id == prefilledOrderId,
              )
              .firstOrNull;
        }
        selected ??= contexts.options.first;
        emit(CreateQueryReady(contexts: contexts, selected: selected));
      },
      onFailure: (failure) => emit(CreateQueryError(failure.message)),
    );
  }

  void select(SupportContextOption option) {
    final state = this.state;
    if (state is! CreateQueryReady || state.submitting) return;
    emit(state.copyWith(selected: option, clearError: true));
  }

  Future<void> submit({
    required String subject,
    required String message,
  }) async {
    final state = this.state;
    if (state is! CreateQueryReady || state.selected == null) return;
    emit(state.copyWith(submitting: true, clearError: true));
    final selected = state.selected!;
    final result = await _createSupportQuery(
      accountId: accountId,
      subject: subject,
      message: message,
      projectId: selected.kind == SupportContextKind.project
          ? selected.id
          : null,
      orderId: selected.kind == SupportContextKind.order ? selected.id : null,
    );
    result.fold(
      onSuccess: (query) => emit(CreateQuerySuccess(query)),
      onFailure: (failure) => emit(
        state.copyWith(submitting: false, errorMessage: failure.message),
      ),
    );
  }
}
