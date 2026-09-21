import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/repositories/asset_access_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class RequestAssetAccess {
  const RequestAssetAccess(this._repository);
  final AssetAccessRepository _repository;

  Future<Result<AssetAccess>> call(String assetId) {
    return _repository.requestAssetAccess(assetId);
  }
}
