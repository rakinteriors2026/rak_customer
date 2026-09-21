import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';

class GetNotifications {
  const GetNotifications(this._repository);
  final NotificationRepository _repository;

  Future<Result<List<InAppNotification>>> call(String accountId) {
    return _repository.getNotifications(accountId);
  }
}
