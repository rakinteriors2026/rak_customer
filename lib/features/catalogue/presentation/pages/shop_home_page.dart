import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/core/domain/entities/home_project_progress.dart';
import 'package:rak_customer/core/domain/repositories/home_project_repository.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';
import 'package:rak_customer/shared/widgets/rak_progress_bar.dart';

/// Storefront. Interior progress appears when this mobile has a RAK project.
class ShopHomePage extends StatelessWidget {
  const ShopHomePage({super.key, required this.interiorAccounts});

  final Stream<Account?> interiorAccounts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogueCubit>()..load(),
      child: _ShopHomeView(interiorAccounts: interiorAccounts),
    );
  }
}

class _ShopHomeView extends StatelessWidget {
  const _ShopHomeView({required this.interiorAccounts});

  final Stream<Account?> interiorAccounts;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Home',
      subtitle: 'Furniture and finishes',
      child: BlocBuilder<CatalogueCubit, CatalogueState>(
        builder: (context, state) {
          return switch (state) {
            CatalogueLoading() => const AppLoading(),
            CatalogueEmpty() => _ShopHomeBody(
              products: const [],
              interiorAccounts: interiorAccounts,
            ),
            CatalogueError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<CatalogueCubit>().load(),
            ),
            CatalogueLoaded(:final allProducts) => _ShopHomeBody(
              products: allProducts.take(4).toList(),
              interiorAccounts: interiorAccounts,
            ),
          };
        },
      ),
    );
  }
}

class _ShopHomeBody extends StatelessWidget {
  const _ShopHomeBody({
    required this.products,
    required this.interiorAccounts,
  });

  final List<CatalogueProduct> products;
  final Stream<Account?> interiorAccounts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        const RakPhoto(asset: 'assets/photos/hero_home.png', height: 200),
        SizedBox(height: context.s(12)),
        const FigText(
          'Pieces for the home you are making.',
          style: AppText.screenTitle,
        ),
        SizedBox(height: context.s(4)),
        const FigText(
          'Order from the shop, or ask for a quote.',
          style: AppText.caption,
        ),
        _InteriorWork(accounts: interiorAccounts),
        if (products.isNotEmpty) ...[
          SizedBox(height: context.s(20)),
          SizedBox(
            height: context.productCardExtent,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => SizedBox(width: context.s(12)),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: context.s(AppLayout.productCardWidth),
                  child: ProductCard(
                    product: product,
                    onTap: () => context.push('/shop/products/${product.id}'),
                  ),
                );
              },
            ),
          ),
        ],
        SizedBox(height: context.s(8)),
        _Row(
          title: 'Shop',
          detail: 'All furniture and finishes',
          onTap: () => context.go('/shop'),
        ),
        const Divider(height: 1, color: AppColors.line),
        _Row(
          title: 'The sales kit',
          detail: 'A project and the finish inside it',
          onTap: () => context.push('/sales-kit'),
        ),
        const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}

class _InteriorWork extends StatelessWidget {
  const _InteriorWork({required this.accounts});

  final Stream<Account?> accounts;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Account?>(
      stream: accounts,
      builder: (context, snapshot) {
        final account = snapshot.data;
        if (account == null) return const SizedBox.shrink();
        return _InteriorProjects(key: ValueKey(account.id), accountId: account.id);
      },
    );
  }
}

class _InteriorProjects extends StatefulWidget {
  const _InteriorProjects({super.key, required this.accountId});

  final String accountId;

  @override
  State<_InteriorProjects> createState() => _InteriorProjectsState();
}

class _InteriorProjectsState extends State<_InteriorProjects> {
  late final Future<List<HomeProjectProgress>> _projects;

  @override
  void initState() {
    super.initState();
    _projects = sl<HomeProjectRepository>().progressFor(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomeProjectProgress>>(
      future: _projects,
      builder: (context, snapshot) {
        final projects = snapshot.data;
        if (projects == null || projects.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.s(24)),
            const FigText('Your projects', style: AppText.screenTitle),
            SizedBox(height: context.s(8)),
            for (var i = 0; i < projects.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: AppColors.line),
              _ProjectRow(project: projects[i]),
            ],
            const Divider(height: 1, color: AppColors.line),
            SizedBox(height: context.s(8)),
          ],
        );
      },
    );
  }
}

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.project});

  final HomeProjectProgress project;

  @override
  Widget build(BuildContext context) {
    final percent = project.progressPercent;
    return InkWell(
      onTap: () => context.push('/projects'),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(14)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(project.name, style: AppText.label),
                  SizedBox(height: context.s(2)),
                  FigText(
                    '${project.phaseLabel} · ${project.siteLabel}',
                    style: AppText.caption,
                  ),
                  if (percent != null) ...[
                    SizedBox(height: context.s(8)),
                    FigText('$percent% complete', style: AppText.caption),
                    SizedBox(height: context.s(6)),
                    RakProgressBar(value: percent / 100),
                  ],
                ],
              ),
            ),
            SizedBox(width: context.s(12)),
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

class _Row extends StatelessWidget {
  const _Row({required this.title, required this.detail, required this.onTap});

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
