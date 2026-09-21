import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';

class NotificationsLocalDatasource {
  NotificationsLocalDatasource(this._db);
  final AppDatabase _db;

  Future<List<InAppNotification>> listOwned(String accountId) async {
    final rows =
        await (_db.select(_db.inAppNotifications)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return rows.map(_toNotification).toList();
  }

  Future<InAppNotification> markRead({
    required String accountId,
    required String notificationId,
  }) async {
    final row =
        await (_db.select(_db.inAppNotifications)..where(
              (t) =>
                  t.id.equals(notificationId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw const NotFoundFailure('This notification is not available.');
    }
    await (_db.update(_db.inAppNotifications)
          ..where((t) => t.id.equals(notificationId)))
        .write(const InAppNotificationsCompanion(read: Value(true)));
    return _toNotification(row).copyWith(read: true);
  }

  Future<NotificationDestination> recheckAccess({
    required String accountId,
    required InAppNotification notification,
  }) async {
    if (!notification.hasTarget) {
      return const NotificationDestinationNone();
    }
    if (notification.targetType == 'project') {
      final project =
          await (_db.select(_db.projects)..where(
                (t) =>
                    t.id.equals(notification.targetId) &
                    t.accountId.equals(accountId),
              ))
              .getSingleOrNull();
      if (project == null) {
        return const NotificationDestinationDenied();
      }
      return NotificationDestinationProject(project.id);
    }
    if (notification.targetType == 'document') {
      final document =
          await (_db.select(_db.projectDocuments)..where(
                (t) =>
                    t.id.equals(notification.targetId) &
                    t.published.equals(true),
              ))
              .getSingleOrNull();
      if (document == null) {
        return const NotificationDestinationDenied();
      }
      final project =
          await (_db.select(_db.projects)..where(
                (t) =>
                    t.id.equals(document.projectId) &
                    t.accountId.equals(accountId),
              ))
              .getSingleOrNull();
      if (project == null) {
        return const NotificationDestinationDenied();
      }
      return NotificationDestinationProject(project.id);
    }
    return const NotificationDestinationDenied();
  }

  Future<DeviceRegistration> registerDevice({
    required String accountId,
    required DeviceIdentity identity,
  }) async {
    final existing =
        await (_db.select(_db.devices)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.installationId.equals(identity.installationId),
            ))
            .getSingleOrNull();
    final id = existing?.id ?? 'dev_${accountId}_${identity.installationId}';
    final token = identity.pushPermissionGranted ? identity.pushToken : null;
    await _db
        .into(_db.devices)
        .insertOnConflictUpdate(
          DevicesCompanion.insert(
            id: id,
            accountId: accountId,
            platform: identity.platform,
            installationId: identity.installationId,
            pushToken: Value(token),
          ),
        );
    return DeviceRegistration(
      id: id,
      accountId: accountId,
      platform: identity.platform,
      installationId: identity.installationId,
      pushToken: token,
    );
  }

  Future<void> unregisterDevice({
    required String accountId,
    required String installationId,
  }) async {
    await (_db.delete(_db.devices)..where(
          (t) =>
              t.accountId.equals(accountId) &
              t.installationId.equals(installationId),
        ))
        .go();
  }

  InAppNotification _toNotification(NotificationRow row) {
    return InAppNotification(
      id: row.id,
      title: row.title,
      body: row.body,
      targetType: row.targetType,
      targetId: row.targetId,
      read: row.read,
      createdAt: row.createdAt,
    );
  }
}
