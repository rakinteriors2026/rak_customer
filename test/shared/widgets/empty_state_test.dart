import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';

void main() {
  testWidgets('empty state is distinct from an error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: AppEmptyState(
            title: 'No linked project yet',
            message:
                'This is expected if you are shopping with us. Contact support if you expected a project to appear here.',
            icon: Icons.apartment_outlined,
          ),
        ),
      ),
    );

    expect(find.text('No linked project yet'), findsOneWidget);
    expect(find.textContaining('Something went wrong'), findsNothing);
    expect(find.text('Try again'), findsNothing);
  });
}
