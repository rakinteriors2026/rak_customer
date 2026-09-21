import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/updates/data/datasources/updates_local_datasource.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/domain/repositories/updates_repository.dart';

class UpdatesRepositoryImpl implements UpdatesRepository {
  UpdatesRepositoryImpl(this._datasource);
  final UpdatesLocalDatasource _datasource;

  @override
  Future<Result<PageResult<SiteUpdate>>> getProjectUpdates({
    required String accountId,
    required String projectId,
    String? cursor,
    int pageSize = 20,
  }) async {
    try {
      return Success(
        await _datasource.listPublished(
          accountId: accountId,
          projectId: projectId,
          cursor: cursor,
          pageSize: pageSize,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<AssetAccess>> requestAssetAccess(String assetId) async {
    try {
      return Success(await _datasource.requestAccess(assetId));
    } on Failure catch (failure) {
      _datasource.dropCachedAccess(assetId);
      return Err(failure);
    } catch (_) {
      _datasource.dropCachedAccess(assetId);
      return const Err(UnknownFailure());
    }
  }
}
