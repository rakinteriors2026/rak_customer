import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/domain/entities/session.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/core/storage/session_storage.dart';
import 'package:rak_customer/features/auth/data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthLocalDatasource datasource,
    required SessionStorage sessionStorage,
  }) : _datasource = datasource,
       _sessionStorage = sessionStorage;

  final AuthLocalDatasource _datasource;
  final SessionStorage _sessionStorage;

  @override
  Future<Result<OtpChallenge>> requestOtp({
    required String phone,
    required String purpose,
  }) async {
    try {
      final challenge = await _datasource.requestOtp(
        phone: phone,
        purpose: purpose,
      );
      return Success(challenge);
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<Session>> verifyOtp({
    required String challengeId,
    required String code,
  }) async {
    try {
      final account = await _datasource.verifyOtp(
        challengeId: challengeId,
        code: code,
      );
      final tokens = await _datasource.createSession(account);
      final session = Session(
        account: tokens.account,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      await _sessionStorage.saveSession(
        StoredSession(
          accountId: session.account.id,
          accessToken: session.accessToken,
          refreshToken: session.refreshToken,
        ),
      );
      return Success(session);
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<Session?>> currentSession() async {
    try {
      final stored = await _sessionStorage.readSession();
      if (stored == null) return const Success(null);
      final account = await _datasource.accountById(stored.accountId);
      if (account == null) {
        await _sessionStorage.clearSession();
        return const Success(null);
      }
      return Success(
        Session(
          account: account,
          accessToken: stored.accessToken,
          refreshToken: stored.refreshToken,
        ),
      );
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final stored = await _sessionStorage.readSession();
      if (stored != null) {
        await _datasource.deleteSessionsForAccount(stored.accountId);
      }
      await _sessionStorage.clearSession();
      return const Success(null);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> deleteAccount({
    required String challengeId,
    required String code,
    required String phone,
  }) async {
    try {
      await _datasource.consumeOtp(
        challengeId: challengeId,
        code: code,
        purpose: 'delete_account',
        expectedPhone: phone,
      );
      final stored = await _sessionStorage.readSession();
      if (stored != null) {
        await _datasource.deleteSessionsForAccount(stored.accountId);
      }
      await _sessionStorage.clearSession();
      return const Success(null);
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
