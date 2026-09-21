import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';

class RecheckNotificationAccess {
  const RecheckNotificationAccess(this._repository);
  final NotificationRepository _repository;

  Future<Result<NotificationDestination>> call({
    required String accountId,
    required InAppNotification notification,
  }) {
    return _repository.recheckAccess(
      accountId: accountId,
      notification: notification,
    );
  }
}
