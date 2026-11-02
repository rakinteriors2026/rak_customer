import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/domain/usecases/get_project_updates.dart';
import 'package:rak_customer/features/updates/presentation/cubit/updates_cubit.dart';
import 'package:rak_customer/features/updates/presentation/widgets/asset_thumbnail.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';

class ProjectUpdatesSection extends StatelessWidget {
  const ProjectUpdatesSection({
    super.key,
    required this.accountId,
    required this.projectId,
    this.pageSize = 20,
    this.showHeading = true,
  });

  final String accountId;
  final String projectId;
  final int pageSize;
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdatesCubit(
        getProjectUpdates: sl<GetProjectUpdates>(),
        accountId: accountId,
        projectId: projectId,
        pageSize: pageSize,
      )..load(),
      child: _UpdatesBody(showHeading: showHeading),
    );
  }
}

class _UpdatesBody extends StatelessWidget {
  const _UpdatesBody({required this.showHeading});
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdatesCubit, UpdatesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeading) ...[
              Text(
                'Site updates',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            switch (state) {
              UpdatesLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              UpdatesEmpty() => const AppEmptyState(
                title: 'No site updates yet',
                message:
                    'Published photos and notes from site will appear here.',
                icon: Icons.photo_library_outlined,
              ),
              UpdatesError(:final message) => AppErrorState(
                message: message,
                onRetry: () => context.read<UpdatesCubit>().load(),
              ),
              UpdatesLoaded(
                :final updates,
                :final hasMore,
                :final loadingMore,
              ) =>
                UpdatesFeed(
                  updates: updates,
                  hasMore: hasMore,
                  loadingMore: loadingMore,
                  onLoadMore: () => context.read<UpdatesCubit>().loadMore(),
                ),
            },
          ],
        );
      },
    );
  }
}

class UpdatesFeed extends StatelessWidget {
  const UpdatesFeed({
    super.key,
    required this.updates,
    this.hasMore = false,
    this.loadingMore = false,
    this.onLoadMore,
  });

  final List<SiteUpdate> updates;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    final visible = updates.where((update) => update.published).toList();
    if (visible.isEmpty) {
      return const AppEmptyState(
        title: 'No site updates yet',
        message: 'Published photos and notes from site will appear here.',
        icon: Icons.photo_library_outlined,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final update in visible) _UpdateEntry(update),
        if (hasMore)
          TextButton(
            onPressed: loadingMore ? null : onLoadMore,
            child: Text(loadingMore ? 'Loading…' : 'Load earlier updates'),
          ),
      ],
    );
  }
}

class _UpdateEntry extends StatelessWidget {
  const _UpdateEntry(this.update);
  final SiteUpdate update;

  @override
  Widget build(BuildContext context) {
    if (update.isDraft) return const SizedBox.shrink();
    final photos = update.assets;
    final paired = photos.length > 1;
    return Padding(
      padding: EdgeInsets.only(bottom: context.s(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FigText(
            DateFormatter.displayDate(update.eventAt),
            style: AppText.caption,
          ),
          if (update.note != null) ...[
            SizedBox(height: context.s(6)),
            FigText(update.note!, style: AppText.body),
          ],
          if (photos.isNotEmpty) ...[
            SizedBox(height: context.s(12)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: paired ? 2 : 1,
                mainAxisSpacing: context.s(8),
                crossAxisSpacing: context.s(8),
                childAspectRatio: paired ? 1 : 16 / 10,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(context.s(12)),
                  child: AssetThumbnail(assetId: photos[index].assetId),
                );
              },
            ),
          ],
          SizedBox(height: context.s(16)),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(16)),
        ],
      ),
    );
  }
}
