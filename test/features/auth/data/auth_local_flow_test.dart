import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/domain/clock.dart';
import '../../../helpers/memory_database.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:rak_customer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rak_customer/features/projects/data/datasources/project_local_datasource.dart';
import 'package:rak_customer/features/projects/data/repositories/project_repository_impl.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'local OTP verify stores a session and buyer-only has no projects',
    () async {
      final clock = Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30));
      final storage = InMemorySessionStorage();
      final auth = AuthRepositoryImpl(
        datasource: AuthLocalDatasource(db: db, clock: clock),
        sessionStorage: storage,
      );

      final challenge = await auth.requestOtp(
        phone: '+919876540002',
        purpose: 'login',
      );
      final session = await auth.verifyOtp(
        challengeId: challenge.valueOrNull!.id,
        code: '123456',
      );

      expect(session.valueOrNull?.account.hasProjects, isFalse);
      expect(await storage.readSession(), isNotNull);

      final projects = ProjectRepositoryImpl(ProjectLocalDatasource(db));
      final page = await projects.getMyProjects(
        accountId: SeedData.buyerAccountId,
      );
      expect(page.valueOrNull?.isEmpty, isTrue);

      final denied = await projects.getProject(
        accountId: SeedData.buyerAccountId,
        projectId: SeedData.alBarariId,
      );
      expect(denied.isFailure, isTrue);
    },
  );

  test(
    'wrong or reused OTP stays generic and does not leak account state',
    () async {
      final clock = Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30));
      final auth = AuthRepositoryImpl(
        datasource: AuthLocalDatasource(db: db, clock: clock),
        sessionStorage: InMemorySessionStorage(),
      );
      final challenge = (await auth.requestOtp(
        phone: '+919876540001',
        purpose: 'login',
      )).valueOrNull!;

      final wrong = await auth.verifyOtp(
        challengeId: challenge.id,
        code: '000000',
      );
      expect(wrong.failureOrNull?.message.contains('project'), isFalse);

      final first = await auth.verifyOtp(
        challengeId: challenge.id,
        code: '123456',
      );
      expect(first.isSuccess, isTrue);
      final reused = await auth.verifyOtp(
        challengeId: challenge.id,
        code: '123456',
      );
      expect(reused.isFailure, isTrue);
    },
  );

  test('delete account consumes a delete OTP and clears the session', () async {
    final clock = Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30));
    final storage = InMemorySessionStorage();
    final auth = AuthRepositoryImpl(
      datasource: AuthLocalDatasource(db: db, clock: clock),
      sessionStorage: storage,
    );

    final login = await auth.requestOtp(
      phone: '+919876540002',
      purpose: 'login',
    );
    await auth.verifyOtp(challengeId: login.valueOrNull!.id, code: '123456');
    expect(await storage.readSession(), isNotNull);

    final challenge = await auth.requestOtp(
      phone: '+919876540002',
      purpose: 'delete_account',
    );
    final deleted = await auth.deleteAccount(
      challengeId: challenge.valueOrNull!.id,
      code: '123456',
      phone: '+919876540002',
    );

    expect(deleted.isSuccess, isTrue);
    expect(await storage.readSession(), isNull);

    final reused = await auth.deleteAccount(
      challengeId: challenge.valueOrNull!.id,
      code: '123456',
      phone: '+919876540002',
    );
    expect(reused.isFailure, isTrue);
  });

  test('a login OTP cannot be used to delete an account', () async {
    final clock = Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30));
    final auth = AuthRepositoryImpl(
      datasource: AuthLocalDatasource(db: db, clock: clock),
      sessionStorage: InMemorySessionStorage(),
    );
    final challenge = (await auth.requestOtp(
      phone: '+919876540001',
      purpose: 'login',
    )).valueOrNull!;

    final deleted = await auth.deleteAccount(
      challengeId: challenge.id,
      code: '123456',
      phone: '+919876540001',
    );
    expect(deleted.isFailure, isTrue);
  });
}
