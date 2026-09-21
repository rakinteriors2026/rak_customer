import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/app/app.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';

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

  testWidgets('guest can browse the shop without signing in', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore the shop'));
    await tester.pumpAndSettle();

    expect(find.text('Oak dining table'), findsOneWidget);
    expect(find.text('Shop'), findsWidgets);
  });

  testWidgets('projects tab sends a guest to sign in', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sessionCubit = sl<SessionCubit>();
    await sessionCubit.restore();
    await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore the shop'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your mobile number'), findsOneWidget);
    expect(find.text('Send verification code'), findsOneWidget);
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

    await tester.tap(find.text('Explore the shop'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Walk-in wardrobe'));
    await tester.tap(find.text('Walk-in wardrobe'));
    await tester.pumpAndSettle();

    expect(find.text('Request a quote'), findsOneWidget);
    expect(find.text('Add to cart'), findsNothing);
  });
}
