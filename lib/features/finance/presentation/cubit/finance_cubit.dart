import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/domain/usecases/get_project_finance.dart';

sealed class FinanceState {
  const FinanceState();
}

class FinanceLoading extends FinanceState {
  const FinanceLoading();
}

class FinanceEmpty extends FinanceState {
  const FinanceEmpty();
}

class FinanceLoaded extends FinanceState {
  const FinanceLoaded(this.finance, {required this.stale});
  final ProjectFinance finance;
  final bool stale;
}

class FinanceError extends FinanceState {
  const FinanceError(this.message);
  final String message;
}

class FinanceCubit extends Cubit<FinanceState> {
  FinanceCubit({
    required GetProjectFinance getProjectFinance,
    required Clock clock,
    required this.accountId,
    required this.projectId,
    this.staleAfter = LocalDemoConfig.ledgerStaleAfter,
  }) : _getProjectFinance = getProjectFinance,
       _clock = clock,
       super(const FinanceLoading());

  final GetProjectFinance _getProjectFinance;
  final Clock _clock;
  final String accountId;
  final String projectId;
  final Duration staleAfter;

  Future<void> load() async {
    emit(const FinanceLoading());
    final result = await _getProjectFinance(
      accountId: accountId,
      projectId: projectId,
    );
    result.fold(
      onSuccess: (finance) {
        if (finance == null) {
          emit(const FinanceEmpty());
          return;
        }
        emit(
          FinanceLoaded(
            finance,
            stale: finance.isStaleAt(_clock.now(), staleAfter),
          ),
        );
      },
      onFailure: (failure) => emit(FinanceError(failure.message)),
    );
  }
}
