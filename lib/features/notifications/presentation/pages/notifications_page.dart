import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/usecases/get_notifications.dart';
import 'package:rak_customer/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:rak_customer/features/notifications/domain/usecases/recheck_notification_access.dart';
import 'package:rak_customer/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({
    super.key,
    required this.accountId,
    this.pushPermissionGranted = false,
  });

  final String accountId;
  final bool pushPermissionGranted;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(
        getNotifications: sl<GetNotifications>(),
        markNotificationRead: sl<MarkNotificationRead>(),
        recheckNotificationAccess: sl<RecheckNotificationAccess>(),
        accountId: accountId,
        pushPermissionGranted: pushPermissionGranted,
      )..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationOpenProject) {
          context.go('/projects/${state.projectId}/updates');
        } else if (state is NotificationAccessDenied) {
          context.go('/access-denied');
        }
      },
      builder: (context, state) {
        return RakPage(
          title: 'Your updates',
          subtitle: 'Project and purchase activity',
          onBack: () => context.pop(),
          child: switch (state) {
            NotificationsLoading() ||
            NotificationOpenProject() ||
            NotificationAccessDenied() => const AppLoading(),
            NotificationsEmpty() => const AppEmptyState(
              title: 'No notifications yet',
              message:
                  'Project and order updates will appear here even if push is turned off.',
              icon: Icons.notifications_none,
            ),
            NotificationsError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<NotificationsCubit>().load(),
            ),
            NotificationsLoaded(
              :final notifications,
              :final pushPermissionGranted,
            ) =>
              NotificationsInboxView(
                notifications: notifications,
                pushPermissionGranted: pushPermissionGranted,
                onOpen: (notification) =>
                    context.read<NotificationsCubit>().open(notification),
              ),
          },
        );
      },
    );
  }
}

class NotificationsInboxView extends StatelessWidget {
  const NotificationsInboxView({
    super.key,
    required this.notifications,
    required this.pushPermissionGranted,
    this.onOpen,
  });

  final List<InAppNotification> notifications;
  final bool pushPermissionGranted;
  final void Function(InAppNotification notification)? onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        if (!pushPermissionGranted) ...[
          const RakStatusBanner(
            text:
                'Push is off on this device. You can still read every update here.',
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        ...notifications.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: RakInfoCard(
              title: notification.title,
              detail:
                  '${notification.body}\n${DateFormatter.displayDate(notification.createdAt)}',
              onTap: onOpen == null ? null : () => onOpen!(notification),
            ),
          ),
        ),
      ],
    );
  }
}
