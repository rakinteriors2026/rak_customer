import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_selected_shop_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/select_shop_branch.dart';

class ShopBranchCubit extends Cubit<ShopBranch> {
  ShopBranchCubit({
    required GetSelectedShopBranch getSelectedShopBranch,
    required SelectShopBranch selectShopBranch,
  }) : _getSelectedShopBranch = getSelectedShopBranch,
       _selectShopBranch = selectShopBranch,
       super(ShopBranch.kochi);

  final GetSelectedShopBranch _getSelectedShopBranch;
  final SelectShopBranch _selectShopBranch;

  Future<void> load() async {
    final result = await _getSelectedShopBranch();
    if (isClosed) return;
    result.fold(onSuccess: emit, onFailure: (_) {});
  }

  Future<void> select(String id) async {
    final result = await _selectShopBranch(id);
    if (isClosed) return;
    result.fold(onSuccess: emit, onFailure: (_) {});
  }
}
