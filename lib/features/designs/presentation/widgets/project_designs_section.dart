import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/domain/usecases/get_approved_designs.dart';
import 'package:rak_customer/features/designs/presentation/cubit/designs_cubit.dart';
import 'package:rak_customer/features/designs/presentation/pages/design_viewer_page.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';

class ProjectDesignsSection extends StatelessWidget {
  const ProjectDesignsSection({
    super.key,
    required this.accountId,
    required this.projectId,
    this.showHeading = true,
  });

  final String accountId;
  final String projectId;
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DesignsCubit(
        getApprovedDesigns: sl<GetApprovedDesigns>(),
        accountId: accountId,
        projectId: projectId,
      )..load(),
      child: _DesignsBody(showHeading: showHeading),
    );
  }
}

class _DesignsBody extends StatelessWidget {
  const _DesignsBody({required this.showHeading});
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignsCubit, DesignsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeading) ...[
              Text(
                'Approved designs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            switch (state) {
              DesignsLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              DesignsEmpty() => const AppEmptyState(
                title: 'No approved designs yet',
                message: 'Approved and published drawings will appear here.',
                icon: Icons.architecture_outlined,
              ),
              DesignsError(:final message) => AppErrorState(
                message: message,
                onRetry: () => context.read<DesignsCubit>().load(),
              ),
              DesignsLoaded(:final designs) => DesignsGalleryView(
                designs: designs,
              ),
            },
          ],
        );
      },
    );
  }
}

class DesignsGalleryView extends StatelessWidget {
  const DesignsGalleryView({super.key, required this.designs});

  final List<ApprovedDesign> designs;

  @override
  Widget build(BuildContext context) {
    if (designs.isEmpty) {
      return const AppEmptyState(
        title: 'No approved designs yet',
        message: 'Approved and published drawings will appear here.',
        icon: Icons.architecture_outlined,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: designs.map((design) => _DesignCard(design: design)).toList(),
    );
  }
}

class _DesignCard extends StatelessWidget {
  const _DesignCard({required this.design});
  final ApprovedDesign design;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(design.title, style: Theme.of(context).textTheme.titleSmall),
            Text(
              design.versionLabel,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
            ),
            if (design.assetIds.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: design.assetIds.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppSpacing.xs,
                  crossAxisSpacing: AppSpacing.xs,
                ),
                itemBuilder: (context, index) {
                  final assetId = design.assetIds[index];
                  return Material(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DesignViewerPage(
                              assetId: assetId,
                              title: design.title,
                            ),
                          ),
                        );
                      },
                      child: const Center(
                        child: Icon(
                          Icons.photo_outlined,
                          color: AppColors.primary,
                        ),
                      ),
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
