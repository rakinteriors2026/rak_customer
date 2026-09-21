import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/features/catalogue/data/repositories/shop_branch_repository_impl.dart';

void main() {
  test('Bangalore treats the dining table and sofa as unavailable', () async {
    final repository = ShopBranchRepositoryImpl();
    addTearDown(repository.dispose);

    await repository.selectBranch(ShopBranch.bangalore.id);

    final table = await repository.isProductAvailable(
      productId: 'prod_oak_table',
    );
    final sofa = await repository.isProductAvailable(
      productId: 'prod_linen_sofa',
    );
    final lamp = await repository.isProductAvailable(productId: 'prod_lamp');

    expect(table.valueOrNull, isFalse);
    expect(sofa.valueOrNull, isFalse);
    expect(lamp.valueOrNull, isTrue);
  });

  test('Kochi keeps those pieces available', () async {
    final repository = ShopBranchRepositoryImpl();
    addTearDown(repository.dispose);

    final table = await repository.isProductAvailable(
      productId: 'prod_oak_table',
    );

    expect(table.valueOrNull, isTrue);
    expect((await repository.selectedBranch()).valueOrNull, ShopBranch.kochi);
  });
}
