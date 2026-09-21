import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/result.dart';

abstract class AssetAccessRepository {
  Future<Result<AssetAccess>> requestAssetAccess(String assetId);
}
