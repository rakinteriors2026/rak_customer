import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_purchase_bar.dart';

void main() {
  testWidgets('back control has an accessible Back name', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: RakPage(
          title: 'Checkout',
          subtitle: 'Review your delivery and payment.',
          onBack: () {},
          child: const SizedBox.shrink(),
        ),
      ),
    );

    expect(find.byTooltip('Back'), findsOneWidget);
    expect(find.bySemanticsLabel('Back'), findsOneWidget);
    expect(find.text('‹'), findsNothing);
  });

  testWidgets('checkout layout does not overflow in landscape', (tester) async {
    final overflows = <Object>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      overflows.add(details.exception);
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);

    await tester.binding.setSurfaceSize(const Size(844, 390));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(size: Size(844, 390)),
          child: RakPage(
            title: 'Checkout',
            subtitle: 'Review your delivery and payment.',
            onBack: () {},
            bottomBar: RakPurchaseBar(
              summary: 'Pay securely',
              actionLabel: 'Place order',
              onAction: () {},
            ),
            child: ListView(
              children: const [
                Text('Deliver to your saved address'),
                Text('Estimated delivery'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      overflows.where((error) => error.toString().contains('overflowed')),
      isEmpty,
    );
  });

  testWidgets('opening the keyboard does not unfocus a text field', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const RakPage(
          title: 'RAK interiors',
          subtitle: 'Thoughtfully made. Beautifully yours.',
          child: TextField(
            key: Key('phone'),
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('phone')));
    await tester.pump();
    expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);

    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsNothing);
    expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);
  });
}
