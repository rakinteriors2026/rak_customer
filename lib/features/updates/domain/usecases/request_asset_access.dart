import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/repositories/updates_repository.dart';

class RequestAssetAccess {
  const RequestAssetAccess(this._repository);
  final UpdatesRepository _repository;

  Future<Result<AssetAccess>> call(String assetId) {
    return _repository.requestAssetAccess(assetId);
  }
}
