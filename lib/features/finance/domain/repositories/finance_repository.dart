import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/finance/domain/entities/project_finance.dart';

abstract class FinanceRepository {
  Future<Result<ProjectFinance?>> getProjectFinance({
    required String accountId,
    required String projectId,
  });
}
