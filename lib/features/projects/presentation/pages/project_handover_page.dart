import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_detail_cubit.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

class ProjectHandoverPage extends StatelessWidget {
  const ProjectHandoverPage({
    super.key,
    required this.accountId,
    required this.projectId,
  });

  final String accountId;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProjectDetailCubit>()
            ..load(accountId: accountId, projectId: projectId),
      child: _HandoverView(accountId: accountId, projectId: projectId),
    );
  }
}

class _HandoverView extends StatelessWidget {
  const _HandoverView({required this.accountId, required this.projectId});

  final String accountId;
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
      builder: (context, state) {
        return switch (state) {
          ProjectDetailLoading() => const RakPage(
            title: 'Handover',
            subtitle: 'Final stage of your project',
            child: AppLoading(),
          ),
          ProjectDetailError(:final message) => RakPage(
            title: 'Handover',
            subtitle: 'Final stage of your project',
            onBack: () => context.pop(),
            child: AppErrorState(
              message: message,
              onRetry: () => context.read<ProjectDetailCubit>().load(
                accountId: accountId,
                projectId: projectId,
              ),
            ),
          ),
          ProjectDetailLoaded(:final project) => _HandoverBody(project: project),
        };
      },
    );
  }
}

class _Snag {
  const _Snag({
    required this.title,
    required this.place,
    required this.status,
    required this.asset,
  });

  final String title;
  final String place;
  final String status;
  final String asset;
}

class _HandoverBody extends StatelessWidget {
  const _HandoverBody({required this.project});

  final InteriorProject project;

  static const _villaSnags = [
    _Snag(
      title: 'Skirting gap',
      place: 'Living room',
      status: 'Open',
      asset: 'assets/photos/living_room_design.png',
    ),
    _Snag(
      title: 'Hinge alignment',
      place: 'Wardrobe',
      status: 'In progress',
      asset: 'assets/photos/oak_laminate.png',
    ),
    _Snag(
      title: 'Tap finish',
      place: 'Kitchen',
      status: 'Complete',
      asset: 'assets/photos/courtyard_home.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final published = project.progressPercent != null;
    final handover = project.forecastHandoverAt ?? project.targetHandoverAt;
    final ready = published && project.id == 'prj_albarari';
    return RakPage(
      title: 'Handover',
      subtitle: project.name,
      onBack: () => context.pop(),
      child: ready
          ? ListView(
              padding: context.figPagePadding,
              children: [
                const RakPhoto(
                  asset: 'assets/photos/hero_home.png',
                  height: 220,
                ),
                SizedBox(height: context.s(12)),
                FigText(
                  handover == null
                      ? 'Handover date not published'
                      : 'Forecast handover · ${DateFormatter.displayShort(handover)}',
                  style: AppText.caption,
                ),
                SizedBox(height: context.s(4)),
                const FigText(
                  '2 items still open before you accept the home.',
                  style: AppText.body,
                ),
                SizedBox(height: context.s(22)),
                const FigText('Still to close', style: AppText.screenTitle),
                SizedBox(height: context.s(12)),
                for (final snag in _villaSnags) ...[
                  _SnagRow(snag: snag),
                  const Divider(height: 1, color: AppColors.line),
                ],
                SizedBox(height: context.s(22)),
                const FigText('Documents', style: AppText.screenTitle),
                SizedBox(height: context.s(12)),
                InkWell(
                  onTap: () => context.push('/projects/${project.id}/documents'),
                  child: Row(
                    children: [
                      _Thumb(asset: 'assets/photos/oak_laminate.png'),
                      SizedBox(width: context.s(14)),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FigText(
                              'Checklist and warranty',
                              style: AppText.label,
                            ),
                            FigText(
                              'Published with your project documents',
                              style: AppText.caption,
                            ),
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
                SizedBox(height: context.s(20)),
                const FigText(
                  'Handover is complete when every item above is marked complete and you accept it with your consultant.',
                  style: AppText.caption,
                ),
              ],
            )
          : AppEmptyState(
              title: 'Handover not published',
              message:
                  'Progress has not been published for this project, so handover documents and snags are not shown.',
              actionLabel: 'Back to projects',
              onAction: () => context.go('/projects'),
              icon: Icons.home_work_outlined,
            ),
    );
  }
}

class _SnagRow extends StatelessWidget {
  const _SnagRow({required this.snag});

  final _Snag snag;

  @override
  Widget build(BuildContext context) {
    final done = snag.status == 'Complete';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(12)),
      child: Row(
        children: [
          _Thumb(asset: snag.asset),
          SizedBox(width: context.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText(snag.title, style: AppText.label),
                SizedBox(height: context.s(2)),
                FigText(snag.place, style: AppText.caption),
              ],
            ),
          ),
          FigText(
            snag.status,
            style: AppText.caption,
            color: done ? AppColors.muted : AppColors.ink,
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final size = context.s(64);
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.s(AppRadii.button)),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
