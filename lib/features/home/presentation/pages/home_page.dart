import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/navigation/auth_return.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_list_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/formatters/phone_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_brand_header.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_hero_room.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_progress_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.displayName, this.accountId});

  final String displayName;
  final String? accountId;

  @override
  Widget build(BuildContext context) {
    // — Signed-out guest view —
    if (accountId == null) {
      return RakPage(
        header: const RakBrandHeader(),
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/account');
          }
        },
        child: ListView(
          padding: context.figPagePadding,
          children: [
            SizedBox(height: context.s(8)),
            const RakHeroRoom(art: RakHeroArt.welcome),
            SizedBox(height: context.s(AppSpacing.lg)),
            Text(
              'Your home.\nEvery step, closer.',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: context.s(AppSpacing.xs)),
            Text(
              'Follow your interior project and find considered pieces for your space.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                  ),
            ),
            SizedBox(height: context.s(AppSpacing.lg)),
            RakButton(
              label: 'Sign in',
              onPressed: () => context.push(
                AuthReturn.loginLocation(from: '/projects/overview'),
              ),
            ),
            SizedBox(height: context.s(AppSpacing.sm)),
            RakButton(
              label: 'Browse the shop',
              style: RakButtonStyle.secondary,
              onPressed: () => context.go('/shop'),
            ),
          ],
        ),
      );
    }

    // — Signed-in view —
    return BlocProvider(
      create: (_) => sl<ProjectListCubit>()..load(accountId!),
      child: RakPage(
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/account');
          }
        },
        child: _SignedInHome(
          accountId: accountId!,
          firstName: PhoneFormatter.firstName(displayName),
        ),
      ),
    );
  }
}

class _SignedInHome extends StatelessWidget {
  const _SignedInHome({required this.accountId, required this.firstName});

  final String accountId;
  final String firstName;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectListCubit, ProjectListState>(
      builder: (context, state) {
        return switch (state) {
          ProjectListLoading() => const AppLoading(),
          ProjectListError(:final message) => AppErrorState(
              message: message,
              onRetry: () =>
                  context.read<ProjectListCubit>().load(accountId),
            ),
          ProjectListEmpty() => _EmptyHome(firstName: firstName),
          ProjectListLoaded(:final projects) => _ProjectHome(
              project: projects.first,
              firstName: firstName,
            ),
        };
      },
    );
  }
}

// ─── Empty state (signed-in, no project) ────────────────────────────────────

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({required this.firstName});

  final String firstName;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        SizedBox(height: context.s(8)),

        // Greeting
        FigText('Hi, $firstName.', style: AppText.heading),
        SizedBox(height: context.s(4)),
        FigText(
          'Welcome to RAK.',
          style: AppText.body,
          color: AppColors.muted,
        ),

        SizedBox(height: context.s(AppSpacing.lg)),
        const RakHeroRoom(art: RakHeroArt.home, editorial: true),
        SizedBox(height: context.s(AppSpacing.lg)),

        FigText(
          'No project linked yet',
          style: AppText.screenTitle,
        ),
        SizedBox(height: context.s(AppSpacing.xs)),
        FigText(
          'If you have a RAK project, contact us to verify the mobile number on record.',
          style: AppText.body,
          color: AppColors.muted,
        ),
        SizedBox(height: context.s(AppSpacing.lg)),

        // Actions
        RakButton(
          label: 'How can we help?',
          onPressed: () => context.go('/support'),
        ),
        SizedBox(height: context.s(AppSpacing.sm)),
        RakButton(
          label: 'Browse the shop',
          style: RakButtonStyle.secondary,
          onPressed: () => context.go('/shop'),
        ),

        SizedBox(height: context.s(AppSpacing.xl)),
        const _SalesKitPromo(),
      ],
    );
  }
}

// ─── Project home (signed-in, has project) ──────────────────────────────────

class _ProjectHome extends StatelessWidget {
  const _ProjectHome({required this.project, required this.firstName});

  final InteriorProject project;
  final String firstName;

  @override
  Widget build(BuildContext context) {
    final progress = project.progressPercent;
    final handover =
        project.forecastHandoverAt ?? project.targetHandoverAt;

    return ListView(
      padding: context.figPagePadding,
      children: [
        SizedBox(height: context.s(8)),

        // ── Greeting ──────────────────────────────────────────────────────
        FigText('Hi, $firstName.', style: AppText.heading),
        SizedBox(height: context.s(AppSpacing.sm)),

        // ── Project card ──────────────────────────────────────────────────
        GestureDetector(
          onTap: () => context.go('/projects'),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: EdgeInsets.all(context.s(16)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.s(16)),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FigText(
                            'Your project',
                            style: AppText.caption,
                            color: AppColors.muted,
                          ),
                          SizedBox(height: context.s(2)),
                          FigText(project.name, style: AppText.title),
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
                SizedBox(height: context.s(14)),
                Row(
                  children: [
                    Expanded(
                      child: FigText(
                        project.phaseLabel,
                        style: AppText.caption,
                        color: AppColors.muted,
                      ),
                    ),
                    if (progress != null)
                      FigText(
                        '$progress%',
                        style: AppText.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: context.s(6)),
                RakProgressBar(value: progress == null ? 0 : progress / 100),
                SizedBox(height: context.s(8)),
                FigText(
                  handover == null
                      ? 'Handover date not yet confirmed'
                      : 'Est. handover · ${DateFormatter.displayShort(handover)}',
                  style: AppText.caption,
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: context.s(AppSpacing.lg)),

        // ── Quick links ───────────────────────────────────────────────────
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.doc_text,
          title: 'Review waiting',
          detail: '1 quotation · 1 design',
          onTap: () => context.push(
            '/projects/${project.id}/review',
            extra: project.name,
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.photo,
          title: 'Latest site update',
          detail: 'Your kitchen is taking shape',
          onTap: () => context.push(
            '/projects/${project.id}/updates',
            extra: '/projects/overview',
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.bag,
          title: 'Shop furniture',
          detail: 'Pieces for your space',
          onTap: () => context.go('/shop'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.lightbulb,
          title: 'Ideas & inspiration',
          detail: 'Projects, finishes and materials',
          onTap: () => context.push('/sales-kit'),
        ),
      ],
    );
  }
}

// ─── Shared widgets ──────────────────────────────────────────────────────────

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
        padding: EdgeInsets.symmetric(vertical: context.s(14)),
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

class _SalesKitPromo extends StatelessWidget {
  const _SalesKitPromo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FigText('Ideas for your next space', style: AppText.screenTitle),
        SizedBox(height: context.s(6)),
        FigText(
          'Explore our projects, finishes and materials.',
          style: AppText.body,
          color: AppColors.muted,
        ),
        SizedBox(height: context.s(AppSpacing.sm)),
        RakButton(
          label: 'Explore finishes & materials',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push('/sales-kit'),
        ),
      ],
    );
  }
}
