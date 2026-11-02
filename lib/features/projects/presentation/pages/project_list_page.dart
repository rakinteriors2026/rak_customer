import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_list_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_hero_room.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_progress_bar.dart';

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
      onBack: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/account');
        }
      },
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

  Future<void> _pickProject(BuildContext context) async {
    final id = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.surface,
      barrierColor: const Color(0x801A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.s(24)),
        ),
      ),
      builder: (sheetContext) => _ProjectPickerSheet(
        projects: projects,
        selectedId: selected.id,
      ),
    );
    if (id != null) onSelect(id);
  }

  @override
  Widget build(BuildContext context) {
    final progress = selected.progressPercent;
    final handover = selected.forecastHandoverAt ?? selected.targetHandoverAt;
    return ListView(
      padding: context.figPagePadding,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: projects.length < 2 ? null : () => _pickProject(context),
          child: Row(
            children: [
              Expanded(
                child: FigText(selected.name, style: AppText.heading),
              ),
              if (projects.length > 1)
                Icon(
                  CupertinoIcons.chevron_down,
                  size: context.s(16),
                  color: AppColors.muted,
                ),
            ],
          ),
        ),
        SizedBox(height: context.s(12)),
        Row(
          children: [
            Expanded(
              child: FigText(
                progress == null
                    ? selected.phaseLabel
                    : '${selected.phaseLabel} · $progress%',
                style: AppText.body,
                color: AppColors.muted,
              ),
            ),
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
          title: 'Review',
          detail: 'Quotation and design',
          onTap: () => context.push(
            '/projects/${selected.id}/review',
            extra: selected.name,
          ),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.time,
          title: 'Timeline',
          detail: 'What is complete, and what comes next',
          onTap: () => context.push('/projects/${selected.id}/timeline'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.photo,
          title: 'Photos from your site',
          detail: 'Latest update · ${selected.phaseLabel}',
          onTap: () => context.push('/projects/${selected.id}/updates'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.folder,
          title: 'Documents',
          detail: 'Quotations, agreements and invoices',
          onTap: () => context.push('/projects/${selected.id}/documents'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.square_pencil,
          title: 'Approved designs',
          detail: 'Drawings that are ready to build',
          onTap: () => context.push('/projects/${selected.id}/designs'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.creditcard,
          title: 'Payments',
          detail: 'History and balance',
          onTap: () => context.push('/projects/${selected.id}/payments'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _QuietLink(
          icon: CupertinoIcons.house,
          title: 'Handover',
          detail: 'What to expect when the home is ready',
          onTap: () => context.push('/projects/${selected.id}/handover'),
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

class _ProjectPickerSheet extends StatelessWidget {
  const _ProjectPickerSheet({
    required this.projects,
    required this.selectedId,
  });

  final List<InteriorProject> projects;
  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.s(24),
          context.s(10),
          context.s(24),
          context.s(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: context.s(36),
                height: context.s(4),
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(context.s(2)),
                ),
              ),
            ),
            SizedBox(height: context.s(20)),
            const FigText('Choose a project', style: AppText.screenTitle),
            SizedBox(height: context.s(8)),
            for (final project in projects)
              InkWell(
                onTap: () => Navigator.pop(context, project.id),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.s(14)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FigText(project.name, style: AppText.label),
                            SizedBox(height: context.s(2)),
                            FigText(
                              project.phaseLabel,
                              style: AppText.caption,
                            ),
                          ],
                        ),
                      ),
                      if (project.id == selectedId)
                        Icon(
                          CupertinoIcons.checkmark,
                          size: context.s(18),
                          color: AppColors.ink,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
