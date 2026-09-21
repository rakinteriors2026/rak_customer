import 'package:rak_customer/core/data/datasources/asset_access_local_datasource.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/asset_access_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class AssetAccessRepositoryImpl implements AssetAccessRepository {
  AssetAccessRepositoryImpl(this._datasource);
  final AssetAccessLocalDatasource _datasource;

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
