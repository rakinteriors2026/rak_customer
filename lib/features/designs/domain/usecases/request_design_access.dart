import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/designs/domain/repositories/design_repository.dart';

class RequestDesignAccess {
  const RequestDesignAccess(this._repository);
  final DesignRepository _repository;

  Future<Result<AssetAccess>> call(String assetId) {
    return _repository.requestAccess(assetId);
  }
}
