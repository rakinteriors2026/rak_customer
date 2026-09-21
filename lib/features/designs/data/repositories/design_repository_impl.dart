import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/designs/data/datasources/designs_local_datasource.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/domain/repositories/design_repository.dart';

class DesignRepositoryImpl implements DesignRepository {
  DesignRepositoryImpl(this._datasource);
  final DesignsLocalDatasource _datasource;

  @override
  Future<Result<List<ApprovedDesign>>> getDesigns({
    required String accountId,
    required String projectId,
  }) async {
    try {
      return Success(
        await _datasource.listApprovedPublished(
          accountId: accountId,
          projectId: projectId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<AssetAccess>> requestAccess(String assetId) async {
    try {
      return Success(await _datasource.requestAccess(assetId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
