import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rak_customer/core/storage/session_storage.dart';

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accountId = 'session.account_id';
  static const _access = 'session.access_token';
  static const _refresh = 'session.refresh_token';

  final FlutterSecureStorage _storage;

  @override
  Future<void> saveSession(StoredSession session) async {
    await _storage.write(key: _accountId, value: session.accountId);
    await _storage.write(key: _access, value: session.accessToken);
    await _storage.write(key: _refresh, value: session.refreshToken);
  }

  @override
  Future<StoredSession?> readSession() async {
    final accountId = await _storage.read(key: _accountId);
    final access = await _storage.read(key: _access);
    final refresh = await _storage.read(key: _refresh);
    if (accountId == null || access == null || refresh == null) {
      return null;
    }
    return StoredSession(
      accountId: accountId,
      accessToken: access,
      refreshToken: refresh,
    );
  }

  @override
  Future<void> clearSession() => _storage.deleteAll();
}
