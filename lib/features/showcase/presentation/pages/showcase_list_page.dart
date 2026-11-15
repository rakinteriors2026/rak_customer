import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/presentation/cubit/showcase_list_cubit.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

class ShowcaseListPage extends StatelessWidget {
  const ShowcaseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ShowcaseListCubit>()..load(),
      child: const _ShowcaseListView(),
    );
  }
}

class _ShowcaseListView extends StatelessWidget {
  const _ShowcaseListView();

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Finished homes',
      subtitle: 'Interiors delivered by RAK',
      onBack: () => context.pop(),
      child: BlocBuilder<ShowcaseListCubit, ShowcaseListState>(
        builder: (context, state) {
          return switch (state) {
            ShowcaseListLoading() => const AppLoading(),
            ShowcaseListError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<ShowcaseListCubit>().load(),
            ),
            ShowcaseListLoaded(:final projects) => _ShowcaseListBody(
              projects: projects,
            ),
          };
        },
      ),
    );
  }
}

class _ShowcaseListBody extends StatelessWidget {
  const _ShowcaseListBody({required this.projects});

  final List<ShowcaseProject> projects;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        FigText(
          '${projects.length} homes, start to finish.',
          style: AppText.screenTitle,
        ),
        SizedBox(height: context.s(4)),
        const FigText(
          'Real RAK projects across Kerala — tap any home to explore the '
          'story and the pieces inside.',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(16)),
        for (var i = 0; i < projects.length; i++) ...[
          _ProjectCard(
            project: projects[i],
            onTap: () => context.push('/showcase/${projects[i].id}'),
          ),
          if (i < projects.length - 1) SizedBox(height: context.s(14)),
        ],
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final ShowcaseProject project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppRadii.card);
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RakPhoto(asset: project.coverAsset, height: 170, radius: 0),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(14),
                context.s(12),
                context.s(14),
                context.s(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    project.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.title,
                  ),
                  SizedBox(height: context.s(4)),
                  FigText(
                    '${project.styleLabel} · ${project.homeType}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                  ),
                  SizedBox(height: context.s(6)),
                  FigText(
                    project.locationLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
