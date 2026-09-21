import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationRead {
  const MarkNotificationRead(this._repository);
  final NotificationRepository _repository;

  Future<Result<InAppNotification>> call({
    required String accountId,
    required String notificationId,
  }) {
    return _repository.markRead(
      accountId: accountId,
      notificationId: notificationId,
    );
  }
}
