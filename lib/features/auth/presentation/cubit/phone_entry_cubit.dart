import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';

sealed class PhoneEntryState {
  const PhoneEntryState();
}

class PhoneEntryIdle extends PhoneEntryState {
  const PhoneEntryIdle({this.error});
  final String? error;
}

class PhoneEntrySubmitting extends PhoneEntryState {
  const PhoneEntrySubmitting();
}

class PhoneEntrySuccess extends PhoneEntryState {
  const PhoneEntrySuccess(this.challenge);
  final OtpChallenge challenge;
}

class PhoneEntryCubit extends Cubit<PhoneEntryState> {
  PhoneEntryCubit({required RequestOtp requestOtp})
    : _requestOtp = requestOtp,
      super(const PhoneEntryIdle());

  final RequestOtp _requestOtp;

  Future<void> submit(String phone) async {
    emit(const PhoneEntrySubmitting());
    final result = await _requestOtp(phone);
    result.fold(
      onSuccess: (challenge) => emit(PhoneEntrySuccess(challenge)),
      onFailure: (failure) => emit(PhoneEntryIdle(error: failure.message)),
    );
  }
}
