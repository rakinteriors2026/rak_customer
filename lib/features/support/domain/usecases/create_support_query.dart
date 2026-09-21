import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';

class CreateSupportQuery {
  const CreateSupportQuery(this._repository);
  final SupportRepository _repository;

  Future<Result<SupportQuery>> call({
    required String accountId,
    required String subject,
    required String message,
    String? projectId,
    String? orderId,
  }) {
    return _repository.createQuery(
      accountId: accountId,
      subject: subject,
      message: message,
      projectId: projectId,
      orderId: orderId,
    );
  }
}
