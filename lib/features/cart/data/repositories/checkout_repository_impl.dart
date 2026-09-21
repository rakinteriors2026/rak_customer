import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/cart/data/datasources/checkout_local_datasource.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this._datasource);
  final CheckoutLocalDatasource _datasource;

  @override
  Future<Result<DeliveryAddress?>> getAddress({
    required String accountId,
  }) async {
    try {
      return Success(await _datasource.getAddress(accountId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<DeliveryAddress>> saveAddress({
    required String accountId,
    required String fullName,
    required String mobile,
    required String line,
    required String postcode,
  }) async {
    try {
      return Success(
        await _datasource.saveAddress(
          accountId: accountId,
          fullName: fullName,
          mobile: mobile,
          line: line,
          postcode: postcode,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<ShopOrder>> placeOrder({required String accountId}) async {
    try {
      return Success(await _datasource.placeOrder(accountId: accountId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<ShopOrder>> getOrder({
    required String accountId,
    required String orderId,
  }) async {
    try {
      return Success(
        await _datasource.getOrder(accountId: accountId, orderId: orderId),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<List<ShopOrder>>> listOrders({
    required String accountId,
  }) async {
    try {
      return Success(await _datasource.listOrders(accountId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
