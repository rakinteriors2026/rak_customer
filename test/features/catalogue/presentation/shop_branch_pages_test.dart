import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/shop_branch_pages.dart';

import '../../../helpers/memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpTall(WidgetTester tester, Widget child) async {
    await tester.binding.setSurfaceSize(const Size(390, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(theme: AppTheme.light(), home: child));
    await tester.pumpAndSettle();
  }

  setUp(() async {
    if (sl.isRegistered<SessionCubit>()) {
      await sl.reset();
    }
    await configureDependencies(
      database: createMemoryDatabase(),
      sessionStorage: InMemorySessionStorage(),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('choose branch screen uses the Figma copy', (tester) async {
    await pumpTall(tester, const ChooseBranchPage());

    expect(find.text('Choose your branch'), findsOneWidget);
    expect(find.text('Browse products available near you.'), findsOneWidget);
    expect(find.text('Branch: Kochi'), findsOneWidget);
    expect(
      find.text(
        'Select the location closest to you. Availability may vary by branch.',
      ),
      findsOneWidget,
    );
    expect(find.text('Kochi'), findsOneWidget);
    expect(find.text('Vyttila, Kerala'), findsOneWidget);
    expect(find.text('Trivandrum'), findsOneWidget);
    expect(find.text('Enjakkal, Kerala'), findsOneWidget);
    expect(find.text('Calicut'), findsOneWidget);
    expect(find.text('Pantheerankavu, Kerala'), findsOneWidget);
    expect(find.text('Bangalore'), findsOneWidget);
    expect(find.text('HSR Layout, Karnataka'), findsOneWidget);
  });

  testWidgets('unavailable screen uses the Figma copy', (tester) async {
    await pumpTall(tester, const BranchUnavailablePage());

    expect(find.text('Unavailable here'), findsOneWidget);
    expect(
      find.text('This item is not available at this branch.'),
      findsOneWidget,
    );
    expect(find.text('Branch: Kochi'), findsOneWidget);
    expect(
      find.text(
        'Choose another branch or browse products available at your selected location.',
      ),
      findsOneWidget,
    );
    expect(find.text('Choose another branch'), findsOneWidget);
    expect(find.text('Browse available products'), findsOneWidget);
    expect(find.text('Contact customer support'), findsOneWidget);
  });
}
