import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';

abstract class SupportRepository {
  Future<Result<List<SupportQuery>>> getQueries(String accountId);

  Future<Result<SupportQuery>> getQuery({
    required String accountId,
    required String queryId,
  });

  Future<Result<SupportContexts>> getContexts(String accountId);

  Future<Result<SupportQuery>> createQuery({
    required String accountId,
    required String subject,
    required String message,
    String? projectId,
    String? orderId,
  });
}
