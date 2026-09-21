import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class ListShopBranches {
  const ListShopBranches(this._repository);
  final ShopBranchRepository _repository;

  Future<Result<List<ShopBranch>>> call() => _repository.listBranches();
}
