import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/support/data/datasources/support_local_datasource.dart';
import 'package:rak_customer/features/support/domain/entities/support_query.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';

class SupportRepositoryImpl implements SupportRepository {
  SupportRepositoryImpl(this._datasource);
  final SupportLocalDatasource _datasource;

  @override
  Future<Result<List<SupportQuery>>> getQueries(String accountId) async {
    try {
      return Success(await _datasource.listOwned(accountId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<SupportQuery>> getQuery({
    required String accountId,
    required String queryId,
  }) async {
    try {
      return Success(
        await _datasource.getOwned(accountId: accountId, queryId: queryId),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<SupportContexts>> getContexts(String accountId) async {
    try {
      return Success(await _datasource.listContexts(accountId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<SupportQuery>> createQuery({
    required String accountId,
    required String subject,
    required String message,
    String? projectId,
    String? orderId,
  }) async {
    try {
      return Success(
        await _datasource.create(
          accountId: accountId,
          subject: subject,
          message: message,
          projectId: projectId,
          orderId: orderId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
