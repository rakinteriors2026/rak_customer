import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';
import 'package:rak_customer/features/notifications/domain/usecases/register_device.dart';
import 'package:rak_customer/features/notifications/domain/usecases/unregister_device.dart';

class _MockNotificationRepository extends Mock
    implements NotificationRepository {}

void main() {
  const identity = DeviceIdentity(
    platform: 'test',
    installationId: 'install_1',
    pushPermissionGranted: false,
  );

  late _MockNotificationRepository repository;

  setUp(() {
    repository = _MockNotificationRepository();
  });

  test('register device forwards the identity', () async {
    when(
      () => repository.registerDevice(accountId: 'acc', identity: identity),
    ).thenAnswer(
      (_) async => const Success(
        DeviceRegistration(
          id: 'dev_1',
          accountId: 'acc',
          platform: 'test',
          installationId: 'install_1',
        ),
      ),
    );

    final result = await RegisterDevice(repository, identity)('acc');
    expect(result.valueOrNull?.installationId, 'install_1');
  });

  test('unregister device uses the installation id', () async {
    when(
      () => repository.unregisterDevice(
        accountId: 'acc',
        installationId: 'install_1',
      ),
    ).thenAnswer((_) async => const Success(null));

    final result = await UnregisterDevice(repository, identity)('acc');
    expect(result.isSuccess, isTrue);
    verify(
      () => repository.unregisterDevice(
        accountId: 'acc',
        installationId: 'install_1',
      ),
    ).called(1);
  });
}
