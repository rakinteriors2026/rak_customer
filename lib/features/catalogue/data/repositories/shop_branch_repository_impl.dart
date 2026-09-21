import 'dart:async';

import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class ShopBranchRepositoryImpl implements ShopBranchRepository {
  ShopBranchRepositoryImpl();

  static const _bangaloreUnavailable = {'prod_oak_table', 'prod_linen_sofa'};

  String _selectedId = ShopBranch.kochi.id;
  final _changes = StreamController<ShopBranch>.broadcast();

  @override
  Future<Result<List<ShopBranch>>> listBranches() async {
    return const Success(ShopBranch.all);
  }

  @override
  Future<Result<ShopBranch>> selectedBranch() async {
    return Success(_byId(_selectedId)!);
  }

  @override
  Stream<ShopBranch> watchSelected() async* {
    yield _byId(_selectedId)!;
    yield* _changes.stream;
  }

  @override
  Future<Result<ShopBranch>> selectBranch(String id) async {
    final branch = _byId(id);
    if (branch == null) {
      return const Err(NotFoundFailure('That branch is not available.'));
    }
    _selectedId = branch.id;
    _changes.add(branch);
    return Success(branch);
  }

  @override
  Future<Result<bool>> isProductAvailable({
    required String productId,
    String? branchId,
  }) async {
    final id = branchId ?? _selectedId;
    if (id == ShopBranch.bangalore.id &&
        _bangaloreUnavailable.contains(productId)) {
      return const Success(false);
    }
    return const Success(true);
  }

  void dispose() {
    _changes.close();
  }

  ShopBranch? _byId(String id) {
    for (final branch in ShopBranch.all) {
      if (branch.id == id) return branch;
    }
    return null;
  }
}
