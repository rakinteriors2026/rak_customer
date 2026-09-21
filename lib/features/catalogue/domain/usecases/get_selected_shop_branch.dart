import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class GetSelectedShopBranch {
  const GetSelectedShopBranch(this._repository);
  final ShopBranchRepository _repository;

  Future<Result<ShopBranch>> call() => _repository.selectedBranch();
}
