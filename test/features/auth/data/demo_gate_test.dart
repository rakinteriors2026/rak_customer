import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/auth/data/datasources/auth_local_datasource.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;

  final clock = Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30));

  setUp(() {
    db = createMemoryDatabase();
  });

  tearDown(() async {
    await db.close();
  });

  group('demo mode gate (F-01)', () {
    test('config default is demo-on under debug/profile test runs', () {
      // Tests run in a non-product VM, so the compile-time default must be on
      // and the current demo behaviour unchanged.
      expect(LocalDemoConfig.demoModeEnabled, isTrue);
      expect(LocalDemoConfig.isReleaseDemoBuild, isFalse);
    });

    test('with demo OFF, seedIfNeeded creates no demo accounts or projects',
        () async {
      await db.seedIfNeeded(demoMode: false);

      final accounts = await db.select(db.accounts).get();
      final projects = await db.select(db.projects).get();
      final tickets = await db.select(db.supportQueries).get();
      expect(accounts, isEmpty);
      expect(projects, isEmpty);
      expect(tickets, isEmpty);

      // The public shop catalogue must still be available to guests.
      final products = await db.select(db.products).get();
      expect(products, isNotEmpty);
    });

    test('with demo OFF, requestOtp fails closed and stores no 123456 code',
        () async {
      await db.seedIfNeeded(demoMode: false);
      final datasource =
          AuthLocalDatasource(db: db, clock: clock, demoMode: false);

      await expectLater(
        datasource.requestOtp(phone: '+919876540001', purpose: 'login'),
        throwsA(isA<Failure>()),
      );

      final challenges = await db.select(db.otpChallenges).get();
      expect(challenges, isEmpty);
      expect(
        challenges.where((c) => c.code == LocalDemoConfig.demoOtpCode),
        isEmpty,
      );
    });

    test('with demo ON, seeding and requestOtp behave as before', () async {
      await db.seedIfNeeded(demoMode: true);
      final datasource =
          AuthLocalDatasource(db: db, clock: clock, demoMode: true);

      final accounts = await db.select(db.accounts).get();
      expect(accounts.map((a) => a.phone), contains('+919876540001'));

      final challenge = await datasource.requestOtp(
        phone: '+919876540001',
        purpose: 'login',
      );
      final stored = await (db.select(db.otpChallenges)
            ..where((t) => t.id.equals(challenge.id)))
          .getSingle();
      expect(stored.code, LocalDemoConfig.demoOtpCode);
    });
  });
}
