import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/domain/usecases/get_project_updates.dart';
import 'package:rak_customer/features/updates/presentation/cubit/updates_cubit.dart';
import 'package:rak_customer/features/updates/presentation/widgets/asset_thumbnail.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';

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
      children: [
        ...visible.map(_UpdateCard.new),
        if (hasMore)
          TextButton(
            onPressed: loadingMore ? null : onLoadMore,
            child: Text(loadingMore ? 'Loading…' : 'Load earlier updates'),
          ),
      ],
    );
  }
}

class _UpdateCard extends StatelessWidget {
  const _UpdateCard(this.update);
  final SiteUpdate update;

  @override
  Widget build(BuildContext context) {
    if (update.isDraft) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormatter.displayDate(update.eventAt),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.inkMuted),
            ),
            if (update.note != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(update.note!),
            ],
            if (update.assets.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: update.assets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.xs,
                  crossAxisSpacing: AppSpacing.xs,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AssetThumbnail(
                      assetId: update.assets[index].assetId,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
