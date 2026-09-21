import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_detail_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class ProjectTimelinePage extends StatelessWidget {
  const ProjectTimelinePage({
    super.key,
    required this.projectId,
    required this.accountId,
  });

  final String projectId;
  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProjectDetailCubit>()
            ..load(accountId: accountId, projectId: projectId),
      child: RakPage(
        title: 'Project timeline',
        subtitle: 'Milestones from plan to handover.',
        onBack: () => context.go('/projects'),
        child: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
          builder: (context, state) {
            return switch (state) {
              ProjectDetailLoading() => const AppLoading(),
              ProjectDetailError(:final message) => AppErrorState(
                message: message,
                onRetry: () => context.read<ProjectDetailCubit>().load(
                  accountId: accountId,
                  projectId: projectId,
                ),
              ),
              ProjectDetailLoaded(:final project) => _TimelineBody(
                project: project,
              ),
            };
          },
        ),
      ),
    );
  }
}

class _TimelineBody extends StatelessWidget {
  const _TimelineBody({required this.project});
  final InteriorProject project;

  @override
  Widget build(BuildContext context) {
    final progress = project.progressPercent;
    return ListView(
      padding: context.figPagePadding,
      children: [
        RakStatusBanner(
          text: progress == null
              ? '${project.phaseLabel} in progress'
              : '${project.phaseLabel} in progress · $progress% complete',
        ),
        const SizedBox(height: AppSpacing.md),
        if (project.milestones.isEmpty)
          Text(
            'No milestones published yet.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          )
        else
          ...project.milestones.map(
            (milestone) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: RakInfoCard(
                title: milestone.title,
                detail: [
                  milestone.isCompleted ? 'Completed' : 'Planned',
                  if (milestone.plannedAt != null)
                    DateFormatter.displayShort(milestone.plannedAt!),
                  if (milestone.note != null) milestone.note!,
                ].join(' · '),
              ),
            ),
          ),
        RakButton(
          label: 'Photos from your site',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push('/projects/${project.id}/updates'),
        ),
        const SizedBox(height: AppSpacing.sm),
        RakButton(
          label: 'Ask your consultant',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push('/support/new?projectId=${project.id}'),
        ),
      ],
    );
  }
}
