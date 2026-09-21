import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/domain/repositories/design_repository.dart';

class GetApprovedDesigns {
  const GetApprovedDesigns(this._repository);
  final DesignRepository _repository;

  Future<Result<List<ApprovedDesign>>> call({
    required String accountId,
    required String projectId,
  }) {
    return _repository.getDesigns(accountId: accountId, projectId: projectId);
  }
}
