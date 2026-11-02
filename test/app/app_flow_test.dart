import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/app/app.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/storage/session_storage.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/cart/domain/usecases/add_cart_item.dart';

import '../helpers/memory_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  Future<void> releaseApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  }

  testWidgets('guest can browse the shop without signing in', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    expect(find.text('Oak dining table'), findsOneWidget);
    expect(find.text('Shop'), findsWidgets);
    expect(find.text('0'), findsWidgets);

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    await releaseApp(tester);
  });

  testWidgets('cart count updates when a product is added', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsWidgets);

    await sl<AddCartItem>()(productId: 'prod_oak_table');
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);
    expect(find.text('0'), findsNothing);
    await releaseApp(tester);
  });

  testWidgets('search returns to the shop', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Search furniture'));
    await tester.pumpAndSettle();
    expect(find.text('Search'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Oak dining table'), findsOneWidget);
    await releaseApp(tester);
  });

  testWidgets('projects in account sends a guest to sign in', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your mobile number'), findsOneWidget);
    expect(find.text('Send verification code'), findsOneWidget);
    await releaseApp(tester);
  });

  testWidgets('projects opens above the shop bar', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await sl<SessionStorage>().saveSession(
      const StoredSession(
        accountId: SeedData.projectsAccountId,
        accessToken: 'demo',
        refreshToken: 'demo',
      ),
    );
    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    expect(find.text('My projects'), findsOneWidget);
    expect(find.text('Panampilly Nagar villa'), findsOneWidget);
    expect(find.text('Cart'), findsNothing);
    expect(find.text('Orders'), findsNothing);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Your project'), findsWidgets);
    expect(find.text('Cart'), findsOneWidget);
    await releaseApp(tester);
  });

  testWidgets('product detail shows request a quote for quotation-only items', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 2800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Walk-in wardrobe'));
    await tester.tap(find.text('Walk-in wardrobe'));
    await tester.pumpAndSettle();

    expect(find.text('Request a quote'), findsOneWidget);
    expect(find.text('Add to cart'), findsNothing);
    await releaseApp(tester);
  });
}
