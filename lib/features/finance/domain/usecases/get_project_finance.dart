import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';
import 'package:rak_customer/features/finance/domain/repositories/finance_repository.dart';

class GetProjectFinance {
  const GetProjectFinance(this._repository);
  final FinanceRepository _repository;

  Future<Result<ProjectFinance?>> call({
    required String accountId,
    required String projectId,
  }) {
    return _repository.getProjectFinance(
      accountId: accountId,
      projectId: projectId,
    );
  }
}
