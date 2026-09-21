import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/presentation/pages/access_denied_page.dart';
import 'package:rak_customer/features/notifications/presentation/pages/notifications_page.dart';

void main() {
  testWidgets('push-denied still shows the in-app inbox', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: NotificationsInboxView(
            pushPermissionGranted: false,
            notifications: [
              InAppNotification(
                id: 'ntf_1',
                title: 'Welcome',
                body: 'You can shop without a project.',
                targetType: 'none',
                targetId: '',
                read: false,
                createdAt: DateTime.utc(2026, 9, 1),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.textContaining('Push is off'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
  });

  testWidgets('denied deep link shows a fallback, not a crash', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const AccessDeniedPage()),
    );

    expect(find.textContaining('no longer shared'), findsOneWidget);
    expect(find.text('Back to notifications'), findsOneWidget);
  });
}
