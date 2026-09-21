import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class IsProductAvailableAtBranch {
  const IsProductAvailableAtBranch(this._repository);
  final ShopBranchRepository _repository;

  Future<Result<bool>> call({required String productId, String? branchId}) {
    return _repository.isProductAvailable(
      productId: productId,
      branchId: branchId,
    );
  }
}
