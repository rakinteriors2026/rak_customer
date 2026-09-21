import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/features/auth/domain/usecases/delete_account.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';
import 'package:rak_customer/shared/formatters/otp_formatter.dart';

sealed class ConfirmAccountDeletionState {
  const ConfirmAccountDeletionState();
}

class ConfirmAccountDeletionLoading extends ConfirmAccountDeletionState {
  const ConfirmAccountDeletionLoading();
}

class ConfirmAccountDeletionError extends ConfirmAccountDeletionState {
  const ConfirmAccountDeletionError(this.message);
  final String message;
}

class ConfirmAccountDeletionReady extends ConfirmAccountDeletionState {
  const ConfirmAccountDeletionReady({
    required this.challenge,
    required this.code,
    this.error,
    this.submitting = false,
  });

  final OtpChallenge challenge;
  final String code;
  final String? error;
  final bool submitting;

  bool get canSubmit => code.length == 6 && !submitting;

  ConfirmAccountDeletionReady copyWith({
    OtpChallenge? challenge,
    String? code,
    String? error,
    bool? submitting,
    bool clearError = false,
  }) {
    return ConfirmAccountDeletionReady(
      challenge: challenge ?? this.challenge,
      code: code ?? this.code,
      error: clearError ? null : error ?? this.error,
      submitting: submitting ?? this.submitting,
    );
  }
}

class ConfirmAccountDeletionSuccess extends ConfirmAccountDeletionState {
  const ConfirmAccountDeletionSuccess();
}

class ConfirmAccountDeletionCubit extends Cubit<ConfirmAccountDeletionState> {
  ConfirmAccountDeletionCubit({
    required String phone,
    required RequestOtp requestOtp,
    required DeleteAccount deleteAccount,
  }) : _phone = phone,
       _requestOtp = requestOtp,
       _deleteAccount = deleteAccount,
       super(const ConfirmAccountDeletionLoading());

  final String _phone;
  final RequestOtp _requestOtp;
  final DeleteAccount _deleteAccount;

  Future<void> start() async {
    emit(const ConfirmAccountDeletionLoading());
    final result = await _requestOtp(_phone, purpose: 'delete_account');
    if (isClosed) return;
    result.fold(
      onSuccess: (challenge) =>
          emit(ConfirmAccountDeletionReady(challenge: challenge, code: '')),
      onFailure: (failure) =>
          emit(ConfirmAccountDeletionError(failure.message)),
    );
  }

  void updateCode(String raw) {
    final current = state;
    if (current is! ConfirmAccountDeletionReady || current.submitting) return;
    emit(
      current.copyWith(code: OtpFormatter.digitsOnly(raw), clearError: true),
    );
  }

  Future<void> submit() async {
    final current = state;
    if (current is! ConfirmAccountDeletionReady || !current.canSubmit) return;
    emit(current.copyWith(submitting: true, clearError: true));
    final result = await _deleteAccount(
      challengeId: current.challenge.id,
      code: current.code,
      phone: _phone,
    );
    if (isClosed) return;
    result.fold(
      onSuccess: (_) => emit(const ConfirmAccountDeletionSuccess()),
      onFailure: (failure) =>
          emit(current.copyWith(submitting: false, error: failure.message)),
    );
  }
}
