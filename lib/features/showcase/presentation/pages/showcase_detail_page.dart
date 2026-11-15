import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/presentation/cubit/showcase_detail_cubit.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

class ShowcaseDetailPage extends StatelessWidget {
  const ShowcaseDetailPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ShowcaseDetailCubit>()..load(projectId),
      child: _ShowcaseDetailView(projectId: projectId),
    );
  }
}

class _ShowcaseDetailView extends StatelessWidget {
  const _ShowcaseDetailView({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShowcaseDetailCubit, ShowcaseDetailState>(
      builder: (context, state) {
        return switch (state) {
          ShowcaseDetailLoading() => RakPage(
            title: 'Finished work',
            subtitle: 'A RAK interior',
            onBack: () => context.pop(),
            child: const AppLoading(),
          ),
          ShowcaseDetailError(:final message) => RakPage(
            title: 'Finished work',
            subtitle: 'A RAK interior',
            onBack: () => context.pop(),
            child: AppErrorState(
              message: message,
              onRetry: () =>
                  context.read<ShowcaseDetailCubit>().load(projectId),
            ),
          ),
          ShowcaseDetailLoaded(:final project) => RakPage(
            title: project.title,
            subtitle: '${project.styleLabel} · ${project.homeType}',
            onBack: () => context.pop(),
            bottomBar: _DiscussBar(project: project),
            child: _ShowcaseBody(project: project),
          ),
        };
      },
    );
  }
}

class _ShowcaseBody extends StatelessWidget {
  const _ShowcaseBody({required this.project});

  final ShowcaseProject project;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        RakPhoto(asset: project.coverAsset, height: 220),
        SizedBox(height: context.s(16)),
        FigText(project.summary, style: AppText.heading),
        SizedBox(height: context.s(6)),
        FigText(
          '${project.styleLabel} · ${project.locationLabel}',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(20)),
        _Spec(label: 'Home', value: project.homeType),
        const Divider(height: 1, color: AppColors.line),
        _Spec(label: 'Scope', value: project.scopeLabel),
        const Divider(height: 1, color: AppColors.line),
        SizedBox(height: context.s(22)),
        const FigText('Approach', style: AppText.screenTitle),
        SizedBox(height: context.s(6)),
        FigText(project.story, style: AppText.body),
        if (project.gallery.length > 1) ...[
          SizedBox(height: context.s(24)),
          const FigText('Rooms', style: AppText.screenTitle),
          SizedBox(height: context.s(10)),
          for (final image in project.gallery) ...[
            RakPhoto(asset: image.asset, height: 200),
            if (image.caption != null) ...[
              SizedBox(height: context.s(6)),
              FigText(image.caption!, style: AppText.caption),
            ],
            SizedBox(height: context.s(14)),
          ],
        ],
        SizedBox(height: context.s(10)),
        const FigText('Pieces in this home', style: AppText.screenTitle),
        SizedBox(height: context.s(4)),
        const FigText(
          'Tap a piece to see it in the shop.',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(8)),
        for (var i = 0; i < project.pieces.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.line),
          _PieceRow(piece: project.pieces[i]),
        ],
        const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}

class _PieceRow extends StatelessWidget {
  const _PieceRow({required this.piece});

  final ShowcasePiece piece;

  @override
  Widget build(BuildContext context) {
    final detail = piece.isInShop
        ? piece.categoryLabel
        : (piece.note ?? piece.categoryLabel);
    final row = Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(10)),
      child: Row(
        children: [
          SizedBox(
            width: context.s(56),
            child: RakPhoto(
              asset: piece.imageAsset,
              height: 56,
              radius: AppRadii.banner,
            ),
          ),
          SizedBox(width: context.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText(
                  piece.name,
                  style: AppText.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.s(2)),
                FigText(
                  detail,
                  style: AppText.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (piece.isInShop) ...[
            SizedBox(width: context.s(12)),
            Icon(
              CupertinoIcons.chevron_right,
              size: context.s(14),
              color: AppColors.muted,
            ),
          ],
        ],
      ),
    );
    if (!piece.isInShop) return row;
    return InkWell(
      // `go`, not `push`: this page sits above the shell, and the product
      // route lives inside the shell. Pushing a shell route from here would
      // add a second shell page and trip the duplicate-page-key assertion.
      onTap: () => context.go('/shop/products/${piece.productId}'),
      child: row,
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.s(88),
            child: FigText(label, style: AppText.caption),
          ),
          SizedBox(width: context.s(12)),
          Expanded(child: FigText(value, style: AppText.body)),
        ],
      ),
    );
  }
}

class _DiscussBar extends StatelessWidget {
  const _DiscussBar({required this.project});

  final ShowcaseProject project;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.canvas,
      padding: EdgeInsets.fromLTRB(
        context.s(24),
        context.s(12),
        context.s(24),
        context.s(12),
      ),
      child: SafeArea(
        top: false,
        child: RakButton(
          label: 'Discuss a similar project',
          onPressed: () {
            final uri = Uri(
              path: '/support',
              queryParameters: {
                'subject': project.title,
                'message':
                    'I would like to discuss a home like ${project.title} '
                    '(${project.styleLabel}).',
              },
            );
            context.go(uri.toString());
          },
        ),
      ),
    );
  }
}
