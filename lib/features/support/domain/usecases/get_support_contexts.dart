import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';

class GetSupportContexts {
  const GetSupportContexts(this._repository);
  final SupportRepository _repository;

  Future<Result<SupportContexts>> call(String accountId) {
    return _repository.getContexts(accountId);
  }
}
