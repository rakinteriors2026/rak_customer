import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';

abstract class DesignRepository {
  Future<Result<List<ApprovedDesign>>> getDesigns({
    required String accountId,
    required String projectId,
  });

  Future<Result<AssetAccess>> requestAccess(String assetId);
}
