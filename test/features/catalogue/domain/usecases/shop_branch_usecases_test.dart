import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_selected_shop_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/is_product_available_at_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/list_shop_branches.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/select_shop_branch.dart';

class _MockShopBranchRepository extends Mock implements ShopBranchRepository {}

void main() {
  late _MockShopBranchRepository repository;

  setUp(() {
    repository = _MockShopBranchRepository();
  });

  test('list shop branches returns every branch', () async {
    when(
      () => repository.listBranches(),
    ).thenAnswer((_) async => const Success(ShopBranch.all));

    final result = await ListShopBranches(repository)();

    expect(result.valueOrNull, ShopBranch.all);
  });

  test('get selected shop branch returns the current branch', () async {
    when(
      () => repository.selectedBranch(),
    ).thenAnswer((_) async => const Success(ShopBranch.kochi));

    final result = await GetSelectedShopBranch(repository)();

    expect(result.valueOrNull, ShopBranch.kochi);
  });

  test('select shop branch rejects an empty id', () async {
    final result = await SelectShopBranch(repository)('  ');

    expect(result.failureOrNull, isA<ValidationFailure>());
    expect(result.failureOrNull!.message, 'Choose a branch to continue.');
    verifyNever(() => repository.selectBranch(any()));
  });

  test('select shop branch persists a valid id', () async {
    when(
      () => repository.selectBranch('bangalore'),
    ).thenAnswer((_) async => const Success(ShopBranch.bangalore));

    final result = await SelectShopBranch(repository)('bangalore');

    expect(result.valueOrNull, ShopBranch.bangalore);
  });

  test('is product available at branch asks the repository', () async {
    when(
      () => repository.isProductAvailable(
        productId: 'prod_linen_sofa',
        branchId: 'bangalore',
      ),
    ).thenAnswer((_) async => const Success(false));

    final result = await IsProductAvailableAtBranch(repository)(
      productId: 'prod_linen_sofa',
      branchId: 'bangalore',
    );

    expect(result.valueOrNull, isFalse);
  });
}
