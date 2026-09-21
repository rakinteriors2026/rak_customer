import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/usecases/get_notifications.dart';
import 'package:rak_customer/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:rak_customer/features/notifications/domain/usecases/recheck_notification_access.dart';

sealed class NotificationsState {
  const NotificationsState();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty();
}

class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.notifications,
    required this.pushPermissionGranted,
    this.openingId,
  });

  final List<InAppNotification> notifications;
  final bool pushPermissionGranted;
  final String? openingId;
}

class NotificationsError extends NotificationsState {
  const NotificationsError(this.message);
  final String message;
}

class NotificationOpenProject extends NotificationsState {
  const NotificationOpenProject(this.projectId);
  final String projectId;
}

class NotificationAccessDenied extends NotificationsState {
  const NotificationAccessDenied();
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required GetNotifications getNotifications,
    required MarkNotificationRead markNotificationRead,
    required RecheckNotificationAccess recheckNotificationAccess,
    required this.accountId,
    this.pushPermissionGranted = false,
  }) : _getNotifications = getNotifications,
       _markNotificationRead = markNotificationRead,
       _recheckNotificationAccess = recheckNotificationAccess,
       super(const NotificationsLoading());

  final GetNotifications _getNotifications;
  final MarkNotificationRead _markNotificationRead;
  final RecheckNotificationAccess _recheckNotificationAccess;
  final String accountId;
  final bool pushPermissionGranted;

  Future<void> load() async {
    emit(const NotificationsLoading());
    final result = await _getNotifications(accountId);
    result.fold(
      onSuccess: (notifications) {
        if (notifications.isEmpty) {
          emit(const NotificationsEmpty());
          return;
        }
        emit(
          NotificationsLoaded(
            notifications: notifications,
            pushPermissionGranted: pushPermissionGranted,
          ),
        );
      },
      onFailure: (failure) => emit(NotificationsError(failure.message)),
    );
  }

  Future<void> open(InAppNotification notification) async {
    final current = state;
    if (current is NotificationsLoaded) {
      emit(
        NotificationsLoaded(
          notifications: current.notifications,
          pushPermissionGranted: current.pushPermissionGranted,
          openingId: notification.id,
        ),
      );
    }
    await _markNotificationRead(
      accountId: accountId,
      notificationId: notification.id,
    );
    final result = await _recheckNotificationAccess(
      accountId: accountId,
      notification: notification,
    );
    result.fold(
      onSuccess: (destination) {
        switch (destination) {
          case NotificationDestinationNone():
            load();
          case NotificationDestinationProject(:final projectId):
            emit(NotificationOpenProject(projectId));
          case NotificationDestinationDenied():
            emit(const NotificationAccessDenied());
        }
      },
      onFailure: (_) => emit(const NotificationAccessDenied()),
    );
  }
}
