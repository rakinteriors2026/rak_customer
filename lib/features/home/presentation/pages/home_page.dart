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
            RakButton(
              label: 'Sign in',
              onPressed: () =>
                  context.push(
                    AuthReturn.loginLocation(from: '/projects/overview'),
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            RakButton(
              label: 'Find something for your home',
              style: RakButtonStyle.secondary,
              onPressed: () => context.go('/shop'),
            ),
          ],
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<ProjectListCubit>()..load(accountId!),
      child: RakPage(
        title: 'Welcome home, ${PhoneFormatter.firstName(displayName)}',
        subtitle: 'Your space. Your choices.',
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/account');
          }
        },
        child: _SignedInHome(accountId: accountId!),
      ),
    );
  }
}

class _SignedInHome extends StatelessWidget {
  const _SignedInHome({required this.accountId});
  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectListCubit, ProjectListState>(
      builder: (context, state) {
        return switch (state) {
          ProjectListLoading() => const AppLoading(),
          ProjectListError(:final message) => AppErrorState(
            message: message,
            onRetry: () => context.read<ProjectListCubit>().load(accountId),
          ),
          ProjectListEmpty() => ListView(
            padding: context.figPagePadding,
            children: [
              const RakHeroRoom(art: RakHeroArt.home, editorial: true),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your RAK journey starts here.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'You can still explore and shop. If you already have a RAK project, contact us to verify the registered mobile number.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: AppSpacing.md),
              RakButton(
                label: 'How can we help?',
                onPressed: () => context.go('/support'),
              ),
              const SizedBox(height: AppSpacing.sm),
              RakButton(
                label: 'Find something for your home',
                style: RakButtonStyle.secondary,
                onPressed: () => context.go('/shop'),
              ),
              const SizedBox(height: AppSpacing.md),
              const _SalesKitPromo(),
            ],
          ),
          ProjectListLoaded(:final projects) => _ProjectHome(
            project: projects.first,
          ),
        };
      },
    );
  }
}

class _ProjectHome extends StatelessWidget {
  const _ProjectHome({required this.project});
  final InteriorProject project;

  @override
  Widget build(BuildContext context) {
    final progress = project.progressPercent;
    final handover = project.forecastHandoverAt ?? project.targetHandoverAt;
    return ListView(
      padding: context.figPagePadding,
      children: [
        const RakHeroRoom(art: RakHeroArt.home, editorial: true),
        const SizedBox(height: AppSpacing.lg),
        FigText('Your project', style: AppText.caption, color: AppColors.muted),
        SizedBox(height: context.s(4)),
        GestureDetector(
          onTap: () => context.go('/projects'),
          behavior: HitTestBehavior.opaque,
          child: FigText(project.name, style: AppText.heading),
        ),
        SizedBox(height: context.s(12)),
        Row(
          children: [
            Expanded(
              child: FigText(
                project.phaseLabel,
                style: AppText.body,
                color: AppColors.muted,
              ),
            ),
            if (progress != null) FigText('$progress%', style: AppText.label),
          ],
        ),
        SizedBox(height: context.s(8)),
        RakProgressBar(value: progress == null ? 0 : progress / 100),
        SizedBox(height: context.s(8)),
        FigText(
          handover == null
              ? 'Handover date not yet available'
              : 'Expected handover · ${DateFormatter.displayShort(handover)}',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(8)),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.doc_text,
          title: 'A review is waiting',
          detail: '1 quotation · 1 design',
          onTap: () => context.push(
            '/projects/${project.id}/review',
            extra: project.name,
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.photo,
          title: 'Your kitchen is taking shape',
          detail: 'New site update · Today, 10:30 AM',
          onTap: () => context.push(
            '/projects/${project.id}/updates',
            extra: '/projects/overview',
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.lightbulb,
          title: 'Ideas for your next space',
          detail: 'Projects, finishes and materials',
          onTap: () => context.push('/sales-kit'),
        ),
      ],
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

class _SalesKitPromo extends StatelessWidget {
  const _SalesKitPromo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FigText('Ideas for your next space', style: AppText.screenTitle),
        SizedBox(height: context.s(8)),
        FigText(
          'Explore our projects, finishes and materials.',
          style: AppText.bodyLarge,
          color: AppColors.muted,
        ),
        SizedBox(height: context.s(8)),
        RakButton(
          label: 'Explore the sales kit',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push('/sales-kit'),
        ),
      ],
    );
  }
}
