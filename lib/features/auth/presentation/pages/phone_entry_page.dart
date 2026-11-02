import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/navigation/auth_return.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/auth/presentation/cubit/phone_entry_cubit.dart';
import 'package:rak_customer/shared/widgets/rak_brand_header.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_hero_room.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class PhoneEntryPage extends StatelessWidget {
  const PhoneEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PhoneEntryCubit>(),
      child: const _PhoneEntryView(),
    );
  }
}

class _PhoneEntryView extends StatefulWidget {
  const _PhoneEntryView();

  @override
  State<_PhoneEntryView> createState() => _PhoneEntryViewState();
}

class _PhoneEntryViewState extends State<_PhoneEntryView> {
  final _controller = TextEditingController(text: '+91');
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneEntryCubit, PhoneEntryState>(
      listener: (context, state) {
        if (state is PhoneEntrySuccess) {
          final from = AuthReturn.readFrom(GoRouterState.of(context).uri);
          context.push(
            AuthReturn.otpLocation(from: from),
            extra: state.challenge,
          );
        }
      },
      builder: (context, state) {
        final submitting = state is PhoneEntrySubmitting;
        final error = state is PhoneEntryIdle ? state.error : null;
        final from = AuthReturn.readFrom(GoRouterState.of(context).uri);
        return RakPage(
          onBack: from == null
              ? null
              : () => context.go(AuthReturn.cancelDestination(from)),
          header: const RakBrandHeader(),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              const RakHeroRoom(art: RakHeroArt.welcome),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your home.\nEvery step, closer.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Follow your interior project and find considered pieces for your space.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Mobile number',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                readOnly: submitting,
                decoration: InputDecoration(
                  hintText: 'Enter your mobile number',
                  errorText: error,
                ),
                onSubmitted: submitting
                    ? null
                    : context.read<PhoneEntryCubit>().submit,
              ),
              const SizedBox(height: AppSpacing.md),
              RakButton(
                label: 'Send verification code',
                loading: submitting,
                onPressed: submitting
                    ? null
                    : () => context.read<PhoneEntryCubit>().submit(
                        _controller.text,
                      ),
              ),
              const SizedBox(height: AppSpacing.sm),
              RakButton(
                label: from == null ? 'Explore the shop' : 'Not now',
                style: RakButtonStyle.secondary,
                onPressed: () => context.go(
                  from == null ? '/shop' : AuthReturn.cancelDestination(from),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => context.push('/account/terms'),
                child: Text(
                  'By continuing, you agree to our Terms and Privacy Policy.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Local demo · Code ${LocalDemoConfig.demoOtpCode} · '
                '${LocalDemoConfig.projectsAccountPhone} has projects · '
                '${LocalDemoConfig.buyerOnlyPhone} is shop only',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
