import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';
import 'package:rak_customer/features/auth/domain/usecases/verify_otp.dart';

sealed class OtpEntryState {
  const OtpEntryState();
}

class OtpEntryReady extends OtpEntryState {
  const OtpEntryReady({
    required this.challenge,
    required this.resendIn,
    this.error,
    this.submitting = false,
  });

  final OtpChallenge challenge;
  final Duration resendIn;
  final String? error;
  final bool submitting;

  bool get canResend => resendIn <= Duration.zero;
}

class OtpEntrySuccess extends OtpEntryState {
  const OtpEntrySuccess(this.account);
  final Account account;
}

class OtpEntryCubit extends Cubit<OtpEntryState> {
  OtpEntryCubit({
    required OtpChallenge challenge,
    required VerifyOtp verifyOtp,
    required RequestOtp requestOtp,
    required Clock clock,
  }) : _verifyOtp = verifyOtp,
       _requestOtp = requestOtp,
       _clock = clock,
       super(
         OtpEntryReady(
           challenge: challenge,
           resendIn: _remaining(challenge, clock.now()),
         ),
       ) {
    _tick();
  }

  final VerifyOtp _verifyOtp;
  final RequestOtp _requestOtp;
  final Clock _clock;
  Timer? _timer;

  static Duration _remaining(OtpChallenge challenge, DateTime now) {
    final left = challenge.resendAfter.difference(now.toUtc());
    return left.isNegative ? Duration.zero : left;
  }

  void _tick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is! OtpEntryReady) return;
      emit(
        OtpEntryReady(
          challenge: current.challenge,
          resendIn: _remaining(current.challenge, _clock.now()),
          error: current.error,
          submitting: current.submitting,
        ),
      );
    });
  }

  Future<void> submit(String code) async {
    final current = state;
    if (current is! OtpEntryReady) return;
    emit(
      OtpEntryReady(
        challenge: current.challenge,
        resendIn: current.resendIn,
        submitting: true,
      ),
    );
    final result = await _verifyOtp(
      challengeId: current.challenge.id,
      code: code,
    );
    result.fold(
      onSuccess: (session) => emit(OtpEntrySuccess(session.account)),
      onFailure: (failure) => emit(
        OtpEntryReady(
          challenge: current.challenge,
          resendIn: _remaining(current.challenge, _clock.now()),
          error: failure.message,
        ),
      ),
    );
  }

  Future<void> resend() async {
    final current = state;
    if (current is! OtpEntryReady || !current.canResend) return;
    final result = await _requestOtp(current.challenge.phone);
    result.fold(
      onSuccess: (challenge) => emit(
        OtpEntryReady(
          challenge: challenge,
          resendIn: _remaining(challenge, _clock.now()),
        ),
      ),
      onFailure: (failure) => emit(
        OtpEntryReady(
          challenge: current.challenge,
          resendIn: current.resendIn,
          error: failure.message,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
