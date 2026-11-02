import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/domain/usecases/get_approved_designs.dart';
import 'package:rak_customer/features/designs/presentation/cubit/designs_cubit.dart';
import 'package:rak_customer/features/designs/presentation/design_preview.dart';
import 'package:rak_customer/features/designs/presentation/pages/design_viewer_page.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';

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
    final assetId = design.assetIds.firstOrNull;
    return Padding(
      padding: EdgeInsets.only(bottom: context.s(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetId != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(context.s(12)),
              child: Material(
                color: AppColors.sand,
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
                  child: Image.asset(
                    designPreviewAsset(title: design.title, assetId: assetId),
                    height: context.s(200),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: AppColors.sand,
                      child: SizedBox(
                        height: context.s(200),
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: context.s(10)),
          FigText(design.title, style: AppText.screenTitle),
          SizedBox(height: context.s(2)),
          FigText(design.versionLabel, style: AppText.caption),
        ],
      ),
    );
  }
}
