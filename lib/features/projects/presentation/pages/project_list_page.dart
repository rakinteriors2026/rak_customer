import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_list_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_hero_room.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectListCubit>()..load(accountId),
      child: _ProjectHub(accountId: accountId),
    );
  }
}

class _ProjectHub extends StatefulWidget {
  const _ProjectHub({required this.accountId});
  final String accountId;

  @override
  State<_ProjectHub> createState() => _ProjectHubState();
}

class _ProjectHubState extends State<_ProjectHub> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'My projects',
      subtitle: 'Your home, from plan to handover.',
      child: BlocBuilder<ProjectListCubit, ProjectListState>(
        builder: (context, state) {
          return switch (state) {
            ProjectListLoading() => const AppLoading(),
            ProjectListError(:final message) => AppErrorState(
              message: message,
              onRetry: () =>
                  context.read<ProjectListCubit>().load(widget.accountId),
            ),
            ProjectListEmpty() => ListView(
              padding: context.figPagePadding,
              children: [
                const RakHeroRoom(art: RakHeroArt.home),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No project linked yet',
                  style: Theme.of(context).textTheme.headlineSmall,
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
                  label: 'Contact support',
                  onPressed: () => context.go('/support'),
                ),
                const SizedBox(height: AppSpacing.sm),
                RakButton(
                  label: 'Explore the shop',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.go('/shop'),
                ),
              ],
            ),
            ProjectListLoaded(:final projects) => _HubBody(
              projects: projects,
              selected: projects.firstWhere(
                (project) => project.id == (_selectedId ?? projects.first.id),
                orElse: () => projects.first,
              ),
              onSelect: (id) => setState(() => _selectedId = id),
            ),
          };
        },
      ),
    );
  }
}

class _HubBody extends StatelessWidget {
  const _HubBody({
    required this.projects,
    required this.selected,
    required this.onSelect,
  });

  final List<InteriorProject> projects;
  final InteriorProject selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final progress = selected.progressPercent;
    final handover = selected.forecastHandoverAt ?? selected.targetHandoverAt;
    return ListView(
      padding: context.figPagePadding,
      children: [
        RakButton(
          label: 'Review quotation & design',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push(
            '/projects/${selected.id}/review',
            extra: selected.name,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        RakStatusBanner(
          text: projects.length == 1 ? selected.name : '${selected.name}   ⌄',
          onTap: projects.length < 2
              ? null
              : () async {
                  final id = await showModalBottomSheet<String>(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final project in projects)
                            ListTile(
                              title: Text(project.name),
                              subtitle: Text(project.phaseLabel),
                              onTap: () => Navigator.pop(context, project.id),
                            ),
                        ],
                      ),
                    ),
                  );
                  if (id != null) onSelect(id);
                },
        ),
        const SizedBox(height: AppSpacing.md),
        RakInfoCard(
          title: progress == null
              ? '${selected.phaseLabel} · Progress not yet available'
              : '${selected.phaseLabel} · $progress% complete',
          detail: handover == null
              ? 'Handover date not yet available'
              : 'Expected handover · ${DateFormatter.displayShort(handover)}',
          onTap: () => context.push('/projects/${selected.id}/timeline'),
        ),
        const SizedBox(height: AppSpacing.md),
        RakInfoCard(
          title: 'Timeline & milestones',
          detail: 'See what is complete and what comes next',
          onTap: () => context.push('/projects/${selected.id}/timeline'),
        ),
        const SizedBox(height: AppSpacing.md),
        RakInfoCard(
          title: 'Photos from your site',
          detail: 'Latest update · ${selected.phaseLabel}',
          onTap: () => context.push('/projects/${selected.id}/updates'),
        ),
        const SizedBox(height: AppSpacing.md),
        RakButton(
          label: 'Documents',
          style: RakButtonStyle.plain,
          onPressed: () => context.push('/projects/${selected.id}/documents'),
        ),
        const SizedBox(height: AppSpacing.sm),
        RakButton(
          label: 'Approved designs',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push('/projects/${selected.id}/designs'),
        ),
        const SizedBox(height: AppSpacing.sm),
        RakButton(
          label: 'Payment history & balance',
          style: RakButtonStyle.secondary,
          onPressed: () => context.push('/projects/${selected.id}/payments'),
        ),
      ],
    );
  }
}
