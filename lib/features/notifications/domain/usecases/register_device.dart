import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';

class RegisterDevice {
  const RegisterDevice(this._repository, this._identity);
  final NotificationRepository _repository;
  final DeviceIdentity _identity;

  Future<Result<DeviceRegistration>> call(String accountId) {
    return _repository.registerDevice(
      accountId: accountId,
      identity: _identity,
    );
  }
}
