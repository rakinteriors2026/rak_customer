import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/finance/data/datasources/finance_local_datasource.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/domain/repositories/finance_repository.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._datasource);
  final FinanceLocalDatasource _datasource;

  @override
  Future<Result<ProjectFinance?>> getProjectFinance({
    required String accountId,
    required String projectId,
  }) async {
    try {
      return Success(
        await _datasource.getOwned(accountId: accountId, projectId: projectId),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
