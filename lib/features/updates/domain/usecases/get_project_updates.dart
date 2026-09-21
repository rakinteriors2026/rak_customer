import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/domain/repositories/updates_repository.dart';

class GetProjectUpdates {
  const GetProjectUpdates(this._repository);
  final UpdatesRepository _repository;

  Future<Result<PageResult<SiteUpdate>>> call({
    required String accountId,
    required String projectId,
    String? cursor,
    int pageSize = 20,
  }) {
    return _repository.getProjectUpdates(
      accountId: accountId,
      projectId: projectId,
      cursor: cursor,
      pageSize: pageSize,
    );
  }
}
