import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._datasource);
  final NotificationsLocalDatasource _datasource;

  @override
  Future<Result<List<InAppNotification>>> getNotifications(
    String accountId,
  ) async {
    try {
      return Success(await _datasource.listOwned(accountId));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<InAppNotification>> markRead({
    required String accountId,
    required String notificationId,
  }) async {
    try {
      return Success(
        await _datasource.markRead(
          accountId: accountId,
          notificationId: notificationId,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<NotificationDestination>> recheckAccess({
    required String accountId,
    required InAppNotification notification,
  }) async {
    try {
      return Success(
        await _datasource.recheckAccess(
          accountId: accountId,
          notification: notification,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<DeviceRegistration>> registerDevice({
    required String accountId,
    required DeviceIdentity identity,
  }) async {
    try {
      return Success(
        await _datasource.registerDevice(
          accountId: accountId,
          identity: identity,
        ),
      );
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> unregisterDevice({
    required String accountId,
    required String installationId,
  }) async {
    try {
      await _datasource.unregisterDevice(
        accountId: accountId,
        installationId: installationId,
      );
      return const Success(null);
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
