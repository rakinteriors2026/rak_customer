import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
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
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
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
              onPressed: () => context.push('/login'),
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
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.s(16)),
          decoration: BoxDecoration(
            color: AppColors.sand,
            borderRadius: BorderRadius.circular(context.s(AppRadii.banner)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FigText('Your review matters', style: AppText.bodyLarge),
                    SizedBox(height: context.s(4)),
                    FigText('1 quotation · 1 design', style: AppText.caption),
                  ],
                ),
              ),
              SizedBox(width: context.s(12)),
              RakButton(
                label: 'Review →',
                width: 108,
                onPressed: () => context.push(
                  '/projects/${project.id}/review',
                  extra: project.name,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Material(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.s(AppRadii.banner)),
            side: const BorderSide(color: AppColors.line),
          ),
          child: InkWell(
            onTap: () => context.go('/projects'),
            borderRadius: BorderRadius.circular(context.s(AppRadii.banner)),
            child: Padding(
              padding: EdgeInsets.all(context.s(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    progress == null
                        ? 'YOUR PROJECT'
                        : 'YOUR PROJECT · $progress% COMPLETE',
                    style: AppText.caption.copyWith(
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                    color: AppColors.accent,
                  ),
                  SizedBox(height: context.s(9)),
                  FigText('${project.name}  →', style: AppText.title),
                  SizedBox(height: context.s(9)),
                  Row(
                    children: [
                      if (progress != null) ...[
                        FigText(
                          '$progress%',
                          style: AppText.title,
                          color: AppColors.accent,
                        ),
                        SizedBox(width: context.s(5)),
                      ],
                      FigText(project.phaseLabel, style: AppText.label),
                    ],
                  ),
                  SizedBox(height: context.s(9)),
                  RakProgressBar(value: progress == null ? 0 : progress / 100),
                  SizedBox(height: context.s(9)),
                  FigText(
                    handover == null
                        ? 'Handover date not yet available'
                        : 'Expected handover · ${DateFormatter.displayShort(handover)}',
                    style: AppText.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        RakInfoCard(
          title: 'Your kitchen is taking shape',
          detail: 'New site update · Today, 10:30 AM',
          onTap: () => context.push('/projects/${project.id}/updates'),
        ),
        const SizedBox(height: AppSpacing.md),
        RakButton(
          label: 'Find something for your home',
          style: RakButtonStyle.secondary,
          onPressed: () => context.go('/shop'),
        ),
        const SizedBox(height: AppSpacing.md),
        const _SalesKitPromo(),
      ],
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
