import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/shared/widgets/rak_media_viewer_scaffold.dart';

void main() {
  testWidgets('close button pops the image viewer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const RakMediaViewerScaffold(
                    title: 'Photo',
                    body: SizedBox.expand(),
                  ),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Close'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.text('Open'), findsOneWidget);
    expect(find.byTooltip('Close'), findsNothing);
  });
}
