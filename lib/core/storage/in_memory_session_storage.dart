import 'package:rak_customer/core/storage/session_storage.dart';

class InMemorySessionStorage implements SessionStorage {
  StoredSession? _session;

  @override
  Future<void> saveSession(StoredSession session) async {
    _session = session;
  }

  @override
  Future<StoredSession?> readSession() async => _session;

  @override
  Future<void> clearSession() async {
    _session = null;
  }
}
