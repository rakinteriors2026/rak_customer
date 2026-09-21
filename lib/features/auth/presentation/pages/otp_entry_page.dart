import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/otp_challenge.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';
import 'package:rak_customer/features/auth/domain/usecases/verify_otp.dart';
import 'package:rak_customer/features/auth/presentation/cubit/otp_entry_cubit.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/shared/formatters/otp_formatter.dart';
import 'package:rak_customer/shared/formatters/phone_formatter.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class OtpEntryPage extends StatelessWidget {
  const OtpEntryPage({super.key, required this.challenge});

  final OtpChallenge challenge;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpEntryCubit(
        challenge: challenge,
        verifyOtp: sl<VerifyOtp>(),
        requestOtp: sl<RequestOtp>(),
        clock: sl<Clock>(),
      ),
      child: const _OtpEntryView(),
    );
  }
}

class _OtpEntryView extends StatefulWidget {
  const _OtpEntryView();

  @override
  State<_OtpEntryView> createState() => _OtpEntryViewState();
}

class _OtpEntryViewState extends State<_OtpEntryView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _timerLabel(Duration remaining) {
    final seconds = remaining.inSeconds;
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return 'Resend code in $mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpEntryCubit, OtpEntryState>(
      listenWhen: (previous, current) => current is OtpEntrySuccess,
      listener: (context, state) {
        if (state is OtpEntrySuccess) {
          context.read<SessionCubit>().signedIn(state.account);
          context.go('/home');
        }
      },
      buildWhen: (previous, current) {
        if (previous is OtpEntryReady && current is OtpEntryReady) {
          return previous.error != current.error ||
              previous.submitting != current.submitting ||
              previous.canResend != current.canResend ||
              previous.challenge.id != current.challenge.id;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        if (state is! OtpEntryReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return RakPage(
          title: 'Check your messages',
          subtitle: 'Secure sign-in',
          onBack: () => context.go('/login'),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              Text(
                'Enter the 6-digit code sent to\n${PhoneFormatter.masked(state.challenge.phone)}.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                readOnly: state.submitting,
                style: Theme.of(context).textTheme.headlineSmall,
                inputFormatters: const [OtpInputFormatter()],
                decoration: InputDecoration(
                  hintText: '2  4  8  6  1  0',
                  errorText: state.error,
                ),
                onSubmitted: state.submitting
                    ? null
                    : context.read<OtpEntryCubit>().submit,
              ),
              const SizedBox(height: AppSpacing.md),
              BlocSelector<OtpEntryCubit, OtpEntryState, Duration>(
                selector: (state) =>
                    state is OtpEntryReady ? state.resendIn : Duration.zero,
                builder: (context, resendIn) {
                  final canResend = resendIn <= Duration.zero;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        canResend ? 'Resend code' : _timerLabel(resendIn),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (canResend)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () =>
                                context.read<OtpEntryCubit>().resend(),
                            child: const Text('Resend code'),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              RakButton(
                label: 'Continue',
                loading: state.submitting,
                onPressed: state.submitting
                    ? null
                    : () => context.read<OtpEntryCubit>().submit(
                        _controller.text,
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              RakButton(
                label: 'Change mobile number',
                style: RakButtonStyle.secondary,
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: AppSpacing.md),
              const RakStatusBanner(
                text: 'Your projects are linked securely to your account.',
              ),
            ],
          ),
        );
      },
    );
  }
}
