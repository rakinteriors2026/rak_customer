import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_detail_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({
    super.key,
    required this.projectId,
    required this.accountId,
    this.financeSection,
    this.updatesSection,
    this.documentsSection,
    this.designsSection,
    this.supportEntry,
  });

  final String projectId;
  final String accountId;
  final Widget? financeSection;
  final Widget? updatesSection;
  final Widget? documentsSection;
  final Widget? designsSection;
  final Widget? supportEntry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProjectDetailCubit>()
            ..load(accountId: accountId, projectId: projectId),
      child: _ProjectDetailView(
        accountId: accountId,
        projectId: projectId,
        financeSection: financeSection,
        updatesSection: updatesSection,
        documentsSection: documentsSection,
        designsSection: designsSection,
        supportEntry: supportEntry,
      ),
    );
  }
}

class _ProjectDetailView extends StatelessWidget {
  const _ProjectDetailView({
    required this.accountId,
    required this.projectId,
    this.financeSection,
    this.updatesSection,
    this.documentsSection,
    this.designsSection,
    this.supportEntry,
  });

  final String accountId;
  final String projectId;
  final Widget? financeSection;
  final Widget? updatesSection;
  final Widget? documentsSection;
  final Widget? designsSection;
  final Widget? supportEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project')),
      body: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
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
            ProjectDetailLoaded(:final project) => _ProjectBody(
              project: project,
              financeSection: financeSection,
              updatesSection: updatesSection,
              documentsSection: documentsSection,
              designsSection: designsSection,
              supportEntry: supportEntry,
            ),
          };
        },
      ),
    );
  }
}

class _ProjectBody extends StatelessWidget {
  const _ProjectBody({
    required this.project,
    this.financeSection,
    this.updatesSection,
    this.documentsSection,
    this.designsSection,
    this.supportEntry,
  });
  final InteriorProject project;
  final Widget? financeSection;
  final Widget? updatesSection;
  final Widget? documentsSection;
  final Widget? designsSection;
  final Widget? supportEntry;

  @override
  Widget build(BuildContext context) {
    final now = sl<Clock>().now();
    final progress = project.progressPercent;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(project.name, style: Theme.of(context).textTheme.headlineSmall),
        Text(project.siteLabel, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.phaseLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (progress == null)
                  const Text('Progress not yet available')
                else ...[
                  LinearProgressIndicator(
                    value: progress / 100,
                    color: AppColors.accent,
                    backgroundColor: AppColors.line,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('$progress%'),
                ],
                const SizedBox(height: AppSpacing.md),
                if (project.targetHandoverAt != null)
                  Text(
                    'Target handover  ${DateFormatter.displayDate(project.targetHandoverAt!)}',
                  ),
                if (project.forecastHandoverAt != null)
                  Text(
                    'Forecast handover  ${DateFormatter.displayDate(project.forecastHandoverAt!)}',
                  ),
                Text(
                  'Updated ${DateFormatter.relative(project.updatedAt, now)}',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Timeline', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (project.milestones.isEmpty)
          const Text('No milestones published yet.')
        else
          ...project.milestones.map((m) => _MilestoneTile(milestone: m)),
        if (financeSection != null) ...[
          const SizedBox(height: AppSpacing.lg),
          financeSection!,
        ],
        if (updatesSection != null) ...[
          const SizedBox(height: AppSpacing.lg),
          updatesSection!,
        ],
        if (documentsSection != null) ...[
          const SizedBox(height: AppSpacing.lg),
          documentsSection!,
        ],
        if (designsSection != null) ...[
          const SizedBox(height: AppSpacing.lg),
          designsSection!,
        ],
        if (supportEntry != null) ...[
          const SizedBox(height: AppSpacing.lg),
          supportEntry!,
        ],
      ],
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.milestone});
  final ProjectMilestone milestone;

  @override
  Widget build(BuildContext context) {
    final completed = milestone.isCompleted;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: completed ? AppColors.success : AppColors.inkMuted,
      ),
      title: Text(milestone.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(completed ? 'Completed' : 'Planned'),
          if (milestone.plannedAt != null)
            Text('Planned ${DateFormatter.displayDate(milestone.plannedAt!)}'),
          if (milestone.completedAt != null)
            Text(
              'Completed ${DateFormatter.displayDate(milestone.completedAt!)}',
            ),
          if (milestone.note != null) Text(milestone.note!),
        ],
      ),
    );
  }
}
