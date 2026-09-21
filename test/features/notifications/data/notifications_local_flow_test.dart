import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:rak_customer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rak_customer/features/auth/domain/usecases/get_current_session.dart';
import 'package:rak_customer/features/auth/domain/usecases/logout.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:rak_customer/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/usecases/register_device.dart';
import 'package:rak_customer/features/notifications/domain/usecases/unregister_device.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late NotificationRepositoryImpl repository;
  const identity = DeviceIdentity(
    platform: 'test',
    installationId: 'install_test',
    pushPermissionGranted: false,
  );

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = NotificationRepositoryImpl(NotificationsLocalDatasource(db));
  });

  tearDown(() async {
    await db.close();
  });

  test('registers a device on login and deletes it on logout', () async {
    final register = RegisterDevice(repository, identity);
    final unregister = UnregisterDevice(repository, identity);
    final clock = Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30));
    final auth = AuthRepositoryImpl(
      datasource: AuthLocalDatasource(db: db, clock: clock),
      sessionStorage: InMemorySessionStorage(),
    );
    final sessionCubit = SessionCubit(
      getCurrentSession: GetCurrentSession(auth),
      logout: Logout(auth),
      onSessionEstablished: (accountId) async {
        await register(accountId);
      },
      onSessionCleared: (accountId) async {
        await unregister(accountId);
      },
    );

    final challenge = await auth.requestOtp(
      phone: '+919876540001',
      purpose: 'login',
    );
    final session = await auth.verifyOtp(
      challengeId: challenge.valueOrNull!.id,
      code: '123456',
    );
    sessionCubit.signedIn(session.valueOrNull!.account);
    await Future<void>.delayed(Duration.zero);

    final afterLogin = await (db.select(db.devices)).get();
    expect(afterLogin, hasLength(1));
    expect(afterLogin.single.accountId, SeedData.projectsAccountId);
    expect(afterLogin.single.pushToken, isNull);

    await sessionCubit.signOut();
    final afterLogout = await (db.select(db.devices)).get();
    expect(afterLogout, isEmpty);
    await sessionCubit.close();
  });

  test('deep-link recheck denies a project the account does not own', () async {
    final inbox = await repository.getNotifications(SeedData.projectsAccountId);
    final denied = inbox.valueOrNull!.firstWhere(
      (item) => item.id == SeedData.notificationDeniedId,
    );
    final result = await repository.recheckAccess(
      accountId: SeedData.projectsAccountId,
      notification: denied,
    );
    expect(result.valueOrNull, isA<NotificationDestinationDenied>());
  });

  test('deep-link recheck allows an owned project', () async {
    final notification = InAppNotification(
      id: 'ntf_finance',
      title: 'Payment posted',
      body: 'Progress claim 1 is now on your ledger.',
      targetType: 'project',
      targetId: SeedData.alBarariId,
      read: false,
      createdAt: DateTime.utc(2026, 6, 18, 12, 0),
    );
    final result = await repository.recheckAccess(
      accountId: SeedData.projectsAccountId,
      notification: notification,
    );
    expect(result.valueOrNull, isA<NotificationDestinationProject>());
    expect(
      (result.valueOrNull as NotificationDestinationProject).projectId,
      SeedData.alBarariId,
    );
  });
}
