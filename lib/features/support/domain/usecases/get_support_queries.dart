import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';

class GetSupportQueries {
  const GetSupportQueries(this._repository);
  final SupportRepository _repository;

  Future<Result<List<SupportQuery>>> call(String accountId) {
    return _repository.getQueries(accountId);
  }
}
