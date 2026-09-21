class StoredSession {
  const StoredSession({
    required this.accountId,
    required this.accessToken,
    required this.refreshToken,
  });

  final String accountId;
  final String accessToken;
  final String refreshToken;
}

abstract class SessionStorage {
  Future<void> saveSession(StoredSession session);
  Future<StoredSession?> readSession();
  Future<void> clearSession();
}
