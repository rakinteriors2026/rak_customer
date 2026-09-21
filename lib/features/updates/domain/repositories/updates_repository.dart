import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';

abstract class UpdatesRepository {
  Future<Result<PageResult<SiteUpdate>>> getProjectUpdates({
    required String accountId,
    required String projectId,
    String? cursor,
    int pageSize = 20,
  });

  Future<Result<AssetAccess>> requestAssetAccess(String assetId);
}
