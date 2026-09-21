import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/features/auth/domain/usecases/get_current_session.dart';
import 'package:rak_customer/features/auth/domain/usecases/logout.dart';

sealed class SessionState {
  const SessionState();
}

class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

class SessionAuthenticated extends SessionState {
  const SessionAuthenticated(this.account);
  final Account account;
}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required GetCurrentSession getCurrentSession,
    required Logout logout,
    this.onSessionEstablished,
    this.onSessionCleared,
  }) : _getCurrentSession = getCurrentSession,
       _logout = logout,
       super(const SessionUnknown());

  final GetCurrentSession _getCurrentSession;
  final Logout _logout;
  final Future<void> Function(String accountId)? onSessionEstablished;
  final Future<void> Function(String accountId)? onSessionCleared;

  Future<void> restore() async {
    final result = await _getCurrentSession();
    await result.fold(
      onSuccess: (session) async {
        if (session == null) {
          emit(const SessionUnauthenticated());
          return;
        }
        emit(SessionAuthenticated(session.account));
        await _safeEstablish(session.account.id);
      },
      onFailure: (_) async => emit(const SessionUnauthenticated()),
    );
  }

  void signedIn(Account account) {
    emit(SessionAuthenticated(account));
    unawaited(_safeEstablish(account.id));
  }

  Future<void> signOut() async {
    final session = state;
    if (session is SessionAuthenticated) {
      await _safeClear(session.account.id);
    }
    await _logout();
    emit(const SessionUnauthenticated());
  }

  Future<void> _safeEstablish(String accountId) async {
    try {
      await onSessionEstablished?.call(accountId);
    } catch (_) {}
  }

  Future<void> _safeClear(String accountId) async {
    try {
      await onSessionCleared?.call(accountId);
    } catch (_) {}
  }
}
