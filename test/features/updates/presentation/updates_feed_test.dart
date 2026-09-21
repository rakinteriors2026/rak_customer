import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/presentation/widgets/project_updates_section.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';

void main() {
  testWidgets('draft updates are not rendered even if present in the list', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: UpdatesFeed(
            updates: [
              SiteUpdate(
                id: 'upd_draft',
                projectId: 'prj',
                published: false,
                note: 'Internal only: lighting mock-up, not for the client.',
                eventAt: DateTime.utc(2026, 9, 7),
                sortCursor: '010',
              ),
              SiteUpdate(
                id: 'upd_note',
                projectId: 'prj',
                published: true,
                note: 'Electrician completed first-fix in the guest suite.',
                eventAt: DateTime.utc(2026, 8, 28),
                sortCursor: '008',
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      find.text('Electrician completed first-fix in the guest suite.'),
      findsOneWidget,
    );
    expect(find.textContaining('Internal only'), findsNothing);
  });

  testWidgets('an empty published feed is not an error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: UpdatesFeed(updates: [])),
      ),
    );

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('No site updates yet'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });
}
