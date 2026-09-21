import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class SelectShopBranch {
  const SelectShopBranch(this._repository);
  final ShopBranchRepository _repository;

  Future<Result<ShopBranch>> call(String id) {
    if (id.trim().isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Choose a branch to continue.')),
      );
    }
    return _repository.selectBranch(id);
  }
}
