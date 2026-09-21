import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';

abstract class NotificationRepository {
  Future<Result<List<InAppNotification>>> getNotifications(String accountId);

  Future<Result<InAppNotification>> markRead({
    required String accountId,
    required String notificationId,
  });

  Future<Result<NotificationDestination>> recheckAccess({
    required String accountId,
    required InAppNotification notification,
  });

  Future<Result<DeviceRegistration>> registerDevice({
    required String accountId,
    required DeviceIdentity identity,
  });

  Future<Result<void>> unregisterDevice({
    required String accountId,
    required String installationId,
  });
}
