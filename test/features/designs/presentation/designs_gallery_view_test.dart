import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/presentation/widgets/project_designs_section.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';

void main() {
  testWidgets('gallery is read-only with no approve or reject actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: DesignsGalleryView(
            designs: [
              ApprovedDesign(
                id: 'dsn_living',
                projectId: 'prj',
                title: 'Living room',
                versionLabel: 'Rev C',
                assetIds: ['ast_design_living'],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Living room'), findsOneWidget);
    expect(find.text('Rev C'), findsOneWidget);
    expect(find.text('Approve'), findsNothing);
    expect(find.text('Reject'), findsNothing);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('empty designs is not an error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: DesignsGalleryView(designs: [])),
      ),
    );

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('No approved designs yet'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });
}
