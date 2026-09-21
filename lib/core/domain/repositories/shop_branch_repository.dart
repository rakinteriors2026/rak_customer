import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/result.dart';

abstract class ShopBranchRepository {
  Future<Result<List<ShopBranch>>> listBranches();

  Future<Result<ShopBranch>> selectedBranch();

  Stream<ShopBranch> watchSelected();

  Future<Result<ShopBranch>> selectBranch(String id);

  Future<Result<bool>> isProductAvailable({
    required String productId,
    String? branchId,
  });
}
