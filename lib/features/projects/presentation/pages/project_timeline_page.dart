import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_detail_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_progress_bar.dart';

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
    final milestones = project.milestones;
    final done = milestones.where((milestone) => milestone.isCompleted).length;
    final current = progress == null
        ? -1
        : milestones.indexWhere((milestone) => !milestone.isCompleted);
    return ListView(
      padding: context.figPagePadding,
      children: [
        if (progress == null)
          FigText(project.phaseLabel, style: AppText.screenTitle)
        else ...[
          FigText('$progress%', style: AppText.display),
          SizedBox(height: context.s(4)),
          FigText(project.phaseLabel, style: AppText.body),
          SizedBox(height: context.s(12)),
          RakProgressBar(value: progress / 100),
        ],
        SizedBox(height: context.s(8)),
        FigText(
          milestones.isEmpty
              ? 'No stages published yet.'
              : progress == null
              ? 'Progress has not been published.'
              : '$done of ${milestones.length} stages complete',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(28)),
        for (var i = 0; i < milestones.length; i++)
          _Stage(
            milestone: milestones[i],
            isFirst: i == 0,
            isLast: i == milestones.length - 1,
            isCurrent: i == current,
          ),
        SizedBox(height: context.s(12)),
        _QuietLink(
          title: 'Photos from your site',
          detail: 'Latest published visit',
          onTap: () => context.push('/projects/${project.id}/updates'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          title: 'Ask your consultant',
          detail: 'A question about this timeline',
          onTap: () => context.push('/support/new?projectId=${project.id}'),
        ),
        const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.milestone,
    required this.isFirst,
    required this.isLast,
    required this.isCurrent,
  });

  final ProjectMilestone milestone;
  final bool isFirst;
  final bool isLast;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final done = milestone.isCompleted;
    final reached = done || isCurrent;
    final when = done
        ? milestone.completedAt ?? milestone.plannedAt
        : milestone.plannedAt;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: context.s(22),
            child: Column(
              children: [
                Container(
                  width: 1,
                  height: context.s(6),
                  color: isFirst
                      ? Colors.transparent
                      : reached
                      ? AppColors.ink
                      : AppColors.line,
                ),
                _Dot(done: done, current: isCurrent),
                Expanded(
                  child: Container(
                    width: 1,
                    color: isLast
                        ? Colors.transparent
                        : done
                        ? AppColors.ink
                        : AppColors.line,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.s(14)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : context.s(22)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FigText(
                          milestone.title,
                          style: AppText.label,
                          color: reached ? AppColors.ink : AppColors.muted,
                        ),
                      ),
                      if (isCurrent)
                        const FigText(
                          'Now',
                          style: AppText.caption,
                          color: AppColors.ink,
                        )
                      else if (done)
                        const FigText('Done', style: AppText.caption),
                    ],
                  ),
                  if (when != null) ...[
                    SizedBox(height: context.s(2)),
                    FigText(
                      DateFormatter.displayShort(when),
                      style: AppText.caption,
                    ),
                  ],
                  if (milestone.note != null) ...[
                    SizedBox(height: context.s(2)),
                    FigText(milestone.note!, style: AppText.body),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.done, required this.current});

  final bool done;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final size = context.s(current ? 11 : 8);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? AppColors.ink : AppColors.canvas,
        border: Border.all(
          color: done || current ? AppColors.ink : AppColors.line,
          width: current ? 2 : 1,
        ),
      ),
    );
  }
}

class _QuietLink extends StatelessWidget {
  const _QuietLink({
    required this.title,
    required this.detail,
    required this.onTap,
  });

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
