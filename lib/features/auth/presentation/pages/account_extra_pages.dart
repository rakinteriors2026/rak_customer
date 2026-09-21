import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/auth/domain/usecases/delete_account.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';
import 'package:rak_customer/features/auth/presentation/cubit/confirm_account_deletion_cubit.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/shared/formatters/otp_formatter.dart';
import 'package:rak_customer/shared/launch/external_action.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class AccountContact {
  static const carePhoneDisplay = '+91 99952 86060';
  static const carePhone = '+919995286060';
  static const careEmail = 'customersupport@rakinteriors.in';
  static const servicePhoneDisplay = '+91 95677 66644';
  static const servicePhone = '+919567766644';
  static const serviceEmail = 'services@rakinteriors.com';
  static const websiteUrl = 'https://rakinteriors.in';
}

Future<void> _openOrNotify(
  BuildContext context,
  Future<bool> Function() action,
) async {
  final opened = await action();
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open that just now. Please try again.'),
      ),
    );
  }
}

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Terms & conditions',
      subtitle: 'RAK Interiors · Published project terms',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakStatusBanner(
            text: 'Interior projects · Read the full terms below.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Quotation & scope',
            detail:
                'Published quotations are valid for 30 days. Work outside the estimate is excluded.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Payments & booking',
            detail:
                'Payment stages depend on the project category. Review the booking and payment conditions before proceeding.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Warranty & service',
            detail:
                'Coverage varies by product and brand. The published terms explain exclusions and service conditions.',
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Read full published terms',
            onPressed: () => context.push('/account/terms/published'),
          ),
        ],
      ),
    );
  }
}

class PublishedTermsPage extends StatelessWidget {
  const PublishedTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Published terms',
      subtitle: 'RAK Interiors · Published project terms',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakStatusBanner(
            text: 'Interior projects · Read the full terms below.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Quotation & scope',
            detail:
                'Published quotations are valid for 30 days. Work outside the estimate is excluded.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Payments & booking',
            detail:
                'Payment stages depend on the project category. Review the booking and payment conditions before proceeding.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Warranty & service',
            detail:
                'Coverage varies by product and brand. The published terms explain exclusions and service conditions.',
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Back to terms',
            style: RakButtonStyle.secondary,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'About RAK',
      subtitle: 'Spaces made around you.',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakStatusBanner(text: 'CRAFTING HOMES SINCE 2011'),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Thoughtful interiors.\nPersonal to you.',
            style: AppText.heading.fig(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'RAK Interiors creates customised spaces for homes, flats and villas across South India.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'From design to installation',
            detail:
                'Modular kitchens, wardrobes, living rooms and bedrooms, supported by an in-house manufacturing facility.',
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Contact our team',
            onPressed: () => context.push('/account/customer-support'),
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Explore RAK Interiors',
            style: RakButtonStyle.secondary,
            onPressed: () => _openOrNotify(
              context,
              () => openWebsite(AccountContact.websiteUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerSupportPage extends StatelessWidget {
  const CustomerSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Customer support',
      subtitle: 'Choose how you would like to reach us.',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakStatusBanner(text: 'Customer care · 9:30 AM – 5:30 PM'),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Keep your work ID or project reference handy so the team can help you.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Customer care',
            detail:
                '${AccountContact.carePhoneDisplay}\n${AccountContact.careEmail}',
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Call customer care',
            onPressed: () => _openOrNotify(
              context,
              () => callPhoneNumber(AccountContact.carePhone),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Email customer care',
            style: RakButtonStyle.secondary,
            onPressed: () => _openOrNotify(
              context,
              () => emailAddress(AccountContact.careEmail),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakInfoCard(
            title: 'Product service & warranty',
            detail:
                '${AccountContact.servicePhoneDisplay}\n${AccountContact.serviceEmail}',
          ),
        ],
      ),
    );
  }
}

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Delete account',
      subtitle: 'Review before you continue.',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakInfoCard(
            title: 'Before you delete',
            detail:
                'Deleting your account removes access to your profile, saved products and account history.',
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Download any documents you need before continuing. Account deletion is separate from cancelling an order or project.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Some transaction or project records may need to be retained. Contact support if you need details.',
            style: AppText.caption,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Continue to verification',
            onPressed: () => context.push('/account/delete/confirm'),
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Keep my account',
            style: RakButtonStyle.secondary,
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Questions? Contact support',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push('/account/customer-support'),
          ),
        ],
      ),
    );
  }
}

class ConfirmAccountDeletionPage extends StatelessWidget {
  const ConfirmAccountDeletionPage({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfirmAccountDeletionCubit(
        phone: phone,
        requestOtp: sl<RequestOtp>(),
        deleteAccount: sl<DeleteAccount>(),
      )..start(),
      child: const _ConfirmAccountDeletionView(),
    );
  }
}

class _ConfirmAccountDeletionView extends StatefulWidget {
  const _ConfirmAccountDeletionView();

  @override
  State<_ConfirmAccountDeletionView> createState() =>
      _ConfirmAccountDeletionViewState();
}

class _ConfirmAccountDeletionViewState
    extends State<_ConfirmAccountDeletionView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      ConfirmAccountDeletionCubit,
      ConfirmAccountDeletionState
    >(
      listener: (context, state) async {
        if (state is ConfirmAccountDeletionSuccess) {
          await context.read<SessionCubit>().signOut();
          if (context.mounted) context.go('/login');
        }
      },
      builder: (context, state) {
        return RakPage(
          title: 'Confirm deletion',
          subtitle: 'Verify that this account belongs to you.',
          onBack: () => context.pop(),
          child: switch (state) {
            ConfirmAccountDeletionLoading() => const AppLoading(),
            ConfirmAccountDeletionError(:final message) => AppErrorState(
              message: message,
              onRetry: () =>
                  context.read<ConfirmAccountDeletionCubit>().start(),
            ),
            ConfirmAccountDeletionSuccess() => const AppLoading(),
            ConfirmAccountDeletionReady(
              :final error,
              :final submitting,
              :final canSubmit,
            ) =>
              ListView(
                padding: context.figPagePadding,
                children: [
                  const RakStatusBanner(
                    text: 'This action cannot be undone once completed.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FigText('Verify your identity', style: AppText.title),
                  const SizedBox(height: AppSpacing.sm),
                  FigText(
                    'Use the verification code sent to your registered mobile number to confirm account deletion.',
                    style: AppText.body,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FigText('VERIFICATION CODE', style: AppText.caption),
                  const SizedBox(height: AppSpacing.xs),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    enabled: !submitting,
                    inputFormatters: const [OtpInputFormatter()],
                    decoration: InputDecoration(
                      hintText: 'Enter 6-digit code',
                      errorText: error,
                    ),
                    onChanged: context
                        .read<ConfirmAccountDeletionCubit>()
                        .updateCode,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RakButton(
                    label: 'Verify & delete account',
                    loading: submitting,
                    onPressed: canSubmit
                        ? () => context
                              .read<ConfirmAccountDeletionCubit>()
                              .submit()
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RakButton(
                    label: 'Cancel and keep my account',
                    style: RakButtonStyle.secondary,
                    onPressed: submitting ? null : () => context.go('/account'),
                  ),
                ],
              ),
          },
        );
      },
    );
  }
}
