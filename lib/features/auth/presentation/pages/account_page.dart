import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/shared/formatters/phone_formatter.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state is! SessionAuthenticated) {
          return RakPage(
            title: 'Your account',
            subtitle: 'Sign in for projects, orders and saved addresses.',
            child: ListView(
              padding: context.figPagePadding,
              children: [
                RakButton(
                  label: 'Sign in',
                  onPressed: () => context.push('/login'),
                ),
                const SizedBox(height: AppSpacing.sm),
                RakButton(
                  label: 'Explore the shop',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.go('/shop'),
                ),
                const SizedBox(height: AppSpacing.sm),
                RakButton(
                  label: 'About RAK Interiors',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.push('/account/about'),
                ),
                const SizedBox(height: AppSpacing.sm),
                RakButton(
                  label: 'Terms & conditions',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.push('/account/terms'),
                ),
              ],
            ),
          );
        }
        final account = state.account;
        return RakPage(
          title: 'Your account',
          subtitle: account.displayName,
          child: ListView(
            padding: context.figPagePadding,
            children: [
              RakButton(
                label: 'My favourites',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/favourites'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakInfoCard(
                title: 'Verified mobile',
                detail: PhoneFormatter.masked(account.phone),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakInfoCard(
                title: 'My orders',
                detail: 'Purchases, deliveries and returns',
                onTap: () => context.push('/orders'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakInfoCard(
                title: 'Saved addresses',
                detail: 'Manage your delivery details',
                onTap: () => context.push('/address'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakInfoCard(
                title: 'Notifications',
                detail: 'Project updates and order activity',
                onTap: () => context.push('/notifications'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakInfoCard(
                title: account.hasProjects
                    ? 'Linked projects'
                    : 'No project linked?',
                detail: account.hasProjects
                    ? 'Open your interior project workspace'
                    : 'How to find your RAK project',
                onTap: () => context.go('/projects'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakButton(
                label: 'Contact customer support',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/account/customer-support'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakButton(
                label: 'About RAK Interiors',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/account/about'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakButton(
                label: 'Terms & conditions',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/account/terms'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakButton(
                label: 'Delete account',
                style: RakButtonStyle.destructive,
                onPressed: () => context.push('/account/delete'),
              ),
              const SizedBox(height: AppSpacing.xs),
              RakButton(
                label: 'Sign out',
                style: RakButtonStyle.secondary,
                onPressed: () async {
                  await context.read<SessionCubit>().signOut();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
