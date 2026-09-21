import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';

class UnregisterDevice {
  const UnregisterDevice(this._repository, this._identity);
  final NotificationRepository _repository;
  final DeviceIdentity _identity;

  Future<Result<void>> call(String accountId) {
    return _repository.unregisterDevice(
      accountId: accountId,
      installationId: _identity.installationId,
    );
  }
}
