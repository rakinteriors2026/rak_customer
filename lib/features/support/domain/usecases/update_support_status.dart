import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';

class UpdateSupportStatus {
  const UpdateSupportStatus(this._repository);
  final SupportRepository _repository;

  Future<Result<SupportQuery>> call({
    required String accountId,
    required String queryId,
    required String status,
  }) {
    return _repository.updateStatus(
      accountId: accountId,
      queryId: queryId,
      status: status,
    );
  }
}
