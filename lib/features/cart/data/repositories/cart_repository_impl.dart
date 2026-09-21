import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._datasource);
  final CartLocalDatasource _datasource;

  @override
  Future<Result<ShoppingCart>> getCart({String? accountId}) async {
    try {
      return Success(await _datasource.getOrCreate(accountId: accountId));
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<ShoppingCart>> addItem({
    required String productId,
    String? accountId,
  }) async {
    try {
      return Success(
        await _datasource.addProduct(
          productId: productId,
          accountId: accountId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<ShoppingCart>> setLineQuantity({
    required String lineId,
    required int quantity,
    String? accountId,
  }) async {
    try {
      return Success(
        await _datasource.setLineQuantity(
          lineId: lineId,
          quantity: quantity,
          accountId: accountId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
