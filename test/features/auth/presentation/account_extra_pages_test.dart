import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/auth/presentation/pages/account_extra_pages.dart';
import 'package:rak_customer/features/auth/presentation/pages/account_page.dart';

import '../../../helpers/memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child, {SessionCubit? sessionCubit}) {
    final page = MaterialApp(theme: AppTheme.light(), home: child);
    if (sessionCubit == null) return page;
    return BlocProvider.value(value: sessionCubit, child: page);
  }

  Future<void> pumpTall(
    WidgetTester tester,
    Widget child, {
    SessionCubit? sessionCubit,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(wrap(child, sessionCubit: sessionCubit));
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

  testWidgets('signed-in account lists the new Figma destinations', (tester) async {
    final sessionCubit = sl<SessionCubit>();
    sessionCubit.signedIn(
      const Account(
        id: 'acc',
        phone: '+919876540001',
        displayName: 'Anjali Menon',
        hasProjects: false,
      ),
    );

    await pumpTall(tester, const AccountPage(), sessionCubit: sessionCubit);

    expect(find.text('Contact customer support'), findsOneWidget);
    expect(find.text('About RAK Interiors'), findsOneWidget);
    expect(find.text('Terms & conditions'), findsOneWidget);
    expect(find.text('Delete account'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('terms screen uses the Figma copy', (tester) async {
    await pumpTall(tester, const TermsConditionsPage());

    expect(find.text('Terms & conditions'), findsOneWidget);
    expect(find.text('Interior projects · Read the full terms below.'), findsOneWidget);
    expect(find.text('Quotation & scope'), findsOneWidget);
    expect(find.text('Payments & booking'), findsOneWidget);
    expect(find.text('Warranty & service'), findsOneWidget);
    expect(find.text('Read full published terms'), findsOneWidget);
  });

  testWidgets('about screen uses the Figma copy', (tester) async {
    await pumpTall(tester, const AboutUsPage());

    expect(find.text('About RAK'), findsOneWidget);
    expect(find.text('CRAFTING HOMES SINCE 2011'), findsOneWidget);
    expect(find.text('Contact our team'), findsOneWidget);
    expect(find.text('Explore RAK Interiors'), findsOneWidget);
  });

  testWidgets('customer support screen uses the Figma contact details', (tester) async {
    await pumpTall(tester, const CustomerSupportPage());

    expect(find.text('Customer support'), findsOneWidget);
    expect(find.text('Customer care · 9:30 AM – 5:30 PM'), findsOneWidget);
    expect(find.textContaining('+91 99952 86060'), findsOneWidget);
    expect(find.text('Call customer care'), findsOneWidget);
    expect(find.text('Email customer care'), findsOneWidget);
    expect(find.text('Product service & warranty'), findsOneWidget);
  });

  testWidgets('delete account screen uses the Figma copy', (tester) async {
    await pumpTall(tester, const DeleteAccountPage());

    expect(find.text('Delete account'), findsOneWidget);
    expect(find.text('Before you delete'), findsOneWidget);
    expect(find.text('Continue to verification'), findsOneWidget);
    expect(find.text('Keep my account'), findsOneWidget);
    expect(find.text('Questions? Contact support'), findsOneWidget);
  });
}
