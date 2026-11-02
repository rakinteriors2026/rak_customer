import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/navigation/auth_return.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/shared/formatters/phone_formatter.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
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
                const FigText(
                  'Projects, orders and saved addresses live here once you are signed in.',
                  style: AppText.body,
                  color: AppColors.muted,
                ),
                SizedBox(height: context.s(24)),
                const FigText('Your project', style: AppText.caption),
                SizedBox(height: context.s(8)),
                const Divider(height: 1, color: AppColors.line),
                _QuietLink(
                  icon: CupertinoIcons.house,
                  title: 'Projects',
                  detail: 'Interior work linked to your account',
                  onTap: () => context.push('/projects'),
                ),
                const Divider(height: 1, color: AppColors.line),
                _QuietLink(
                  icon: CupertinoIcons.chat_bubble,
                  title: 'Project support',
                  detail: 'Questions for your consultant',
                  onTap: () => context.push('/support'),
                ),
                const Divider(height: 1, color: AppColors.line),
                SizedBox(height: context.s(20)),
                RakButton(
                  label: 'Sign in',
                  onPressed: () =>
                      context.push(AuthReturn.loginLocation(from: '/account')),
                ),
                SizedBox(height: context.s(28)),
                const Divider(height: 1, color: AppColors.line),
                _QuietLink(
                  icon: CupertinoIcons.bag,
                  title: 'Explore the shop',
                  detail: 'Furniture and finishes',
                  onTap: () => context.go('/shop'),
                ),
                const Divider(height: 1, color: AppColors.line),
                _QuietLink(
                  icon: CupertinoIcons.info,
                  title: 'About RAK Interiors',
                  detail: 'The studio',
                  onTap: () => context.push('/account/about'),
                ),
                const Divider(height: 1, color: AppColors.line),
                _QuietLink(
                  icon: CupertinoIcons.doc_text,
                  title: 'Terms & conditions',
                  detail: 'How we work with you',
                  onTap: () => context.push('/account/terms'),
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
              Row(
                children: [
                  Icon(
                    CupertinoIcons.phone,
                    size: context.s(18),
                    color: AppColors.muted,
                  ),
                  SizedBox(width: context.s(14)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FigText(
                        PhoneFormatter.masked(account.phone),
                        style: AppText.screenTitle,
                      ),
                      SizedBox(height: context.s(2)),
                      const FigText('Verified mobile', style: AppText.caption),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.s(8)),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.heart,
                title: 'Favourites',
                detail: 'Pieces you saved',
                onTap: () => context.push('/favourites'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.doc_text,
                title: 'Quote enquiries',
                detail: 'Requests that are not orders',
                onTap: () => context.push('/enquiries'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.location,
                title: 'Saved addresses',
                detail: 'Delivery details',
                onTap: () => context.push('/address'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.bell,
                title: 'Notifications',
                detail: 'Project updates and order activity',
                onTap: () => context.push('/notifications'),
              ),
              const Divider(height: 1, color: AppColors.line),
              SizedBox(height: context.s(20)),
              const FigText('Your project', style: AppText.caption),
              SizedBox(height: context.s(8)),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.square_list,
                title: 'Project home',
                detail: 'Progress, reviews and site photos',
                onTap: () => context.push('/projects/overview'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.house,
                title: account.hasProjects ? 'Projects' : 'No project linked',
                detail: account.hasProjects
                    ? 'Your interior workspace'
                    : 'How to find your RAK project',
                onTap: () => context.push('/projects'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.chat_bubble,
                title: 'Project support',
                detail: 'Questions for your consultant',
                onTap: () => context.push('/support'),
              ),
              const Divider(height: 1, color: AppColors.line),
              SizedBox(height: context.s(20)),
              const FigText('Studio', style: AppText.caption),
              SizedBox(height: context.s(8)),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.chat_bubble,
                title: 'Contact customer support',
                detail: 'Talk to your consultant',
                onTap: () => context.push('/account/customer-support'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.info,
                title: 'About RAK Interiors',
                detail: 'The studio',
                onTap: () => context.push('/account/about'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.doc_plaintext,
                title: 'Terms & conditions',
                detail: 'How we work with you',
                onTap: () => context.push('/account/terms'),
              ),
              const Divider(height: 1, color: AppColors.line),
              SizedBox(height: context.s(8)),
              _TextAction(
                icon: CupertinoIcons.square_arrow_right,
                label: 'Sign out',
                onTap: () async {
                  await context.read<SessionCubit>().signOut();
                  if (context.mounted) context.go('/login');
                },
              ),
              _TextAction(
                icon: CupertinoIcons.trash,
                label: 'Delete account',
                color: AppColors.error,
                onTap: () => context.push('/account/delete'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuietLink extends StatelessWidget {
  const _QuietLink({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(16)),
        child: Row(
          children: [
            Icon(icon, size: context.s(18), color: AppColors.ink),
            SizedBox(width: context.s(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(title, style: AppText.label),
                  SizedBox(height: context.s(2)),
                  FigText(detail, style: AppText.caption),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: context.s(14),
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? AppColors.ink;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(14)),
        child: Row(
          children: [
            Icon(icon, size: context.s(18), color: ink),
            SizedBox(width: context.s(14)),
            FigText(label, style: AppText.label, color: ink),
          ],
        ),
      ),
    );
  }
}
