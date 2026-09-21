import 'package:drift/drift.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:uuid/uuid.dart';

class AuthLocalDatasource {
  AuthLocalDatasource({
    required AppDatabase db,
    required Clock clock,
    Uuid? uuid,
  }) : _db = db,
       _clock = clock,
       _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  Future<OtpChallenge> requestOtp({
    required String phone,
    required String purpose,
  }) async {
    final now = _clock.now().toUtc();
    final id = _uuid.v4();
    final expiresAt = now.add(LocalDemoConfig.otpTtl);
    final resendAfter = now.add(LocalDemoConfig.resendCooldown);
    await _db
        .into(_db.otpChallenges)
        .insert(
          OtpChallengesCompanion.insert(
            id: id,
            phone: phone,
            purpose: purpose,
            code: LocalDemoConfig.demoOtpCode,
            expiresAt: expiresAt,
            resendAfter: resendAfter,
            createdAt: now,
          ),
        );
    return OtpChallenge(
      id: id,
      phone: phone,
      expiresAt: expiresAt,
      resendAfter: resendAfter,
    );
  }

  Future<OtpChallengeRow> consumeOtp({
    required String challengeId,
    required String code,
    required String purpose,
    String? expectedPhone,
  }) async {
    final now = _clock.now().toUtc();
    final row = await (_db.select(
      _db.otpChallenges,
    )..where((t) => t.id.equals(challengeId))).getSingleOrNull();

    if (row == null ||
        row.consumed ||
        row.expiresAt.isBefore(now) ||
        row.code != code ||
        row.purpose != purpose ||
        (expectedPhone != null && row.phone != expectedPhone)) {
      throw const ValidationFailure(
        'That code did not work. Request a new one and try again.',
      );
    }

    await (_db.update(_db.otpChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .write(const OtpChallengesCompanion(consumed: Value(true)));
    return row;
  }

  Future<Account> verifyOtp({
    required String challengeId,
    required String code,
  }) async {
    final now = _clock.now().toUtc();
    final row = await consumeOtp(
      challengeId: challengeId,
      code: code,
      purpose: 'login',
    );

    final existing = await (_db.select(
      _db.accounts,
    )..where((t) => t.phone.equals(row.phone))).getSingleOrNull();
    if (existing != null) {
      return _toAccount(existing);
    }

    final newId = _uuid.v4();
    await _db
        .into(_db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: newId,
            phone: row.phone,
            displayName: 'Guest buyer',
            hasProjects: false,
            createdAt: now,
          ),
        );
    return Account(
      id: newId,
      phone: row.phone,
      displayName: 'Guest buyer',
      hasProjects: false,
    );
  }

  Future<({Account account, String accessToken, String refreshToken})>
  createSession(Account account) async {
    final now = _clock.now().toUtc();
    final access = _uuid.v4();
    final refresh = _uuid.v4();
    await _db
        .into(_db.authSessions)
        .insert(
          AuthSessionsCompanion.insert(
            id: _uuid.v4(),
            accountId: account.id,
            accessToken: access,
            refreshToken: refresh,
            expiresAt: now.add(LocalDemoConfig.accessTokenTtl),
          ),
        );
    return (account: account, accessToken: access, refreshToken: refresh);
  }

  Future<Account?> accountById(String id) async {
    final row = await (_db.select(
      _db.accounts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toAccount(row);
  }

  Future<void> deleteSessionsForAccount(String accountId) async {
    await (_db.delete(
      _db.authSessions,
    )..where((t) => t.accountId.equals(accountId))).go();
  }

  Account _toAccount(AccountRow row) => Account(
    id: row.id,
    phone: row.phone,
    displayName: row.displayName,
    hasProjects: row.hasProjects,
  );
}
