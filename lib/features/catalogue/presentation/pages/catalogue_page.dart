import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/product_artwork.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key, required this.watchCartCount});

  final Stream<int> Function() watchCartCount;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogueCubit>()..load(),
      child: _CatalogueView(watchCartCount: watchCartCount),
    );
  }
}

class _CatalogueView extends StatelessWidget {
  const _CatalogueView({required this.watchCartCount});

  final Stream<int> Function() watchCartCount;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      header: _ShopHeader(watchCartCount: watchCartCount),
      contentGap: 8,
      child: BlocBuilder<CatalogueCubit, CatalogueState>(
        buildWhen: (previous, current) {
          if (previous is CatalogueLoaded && current is CatalogueLoaded) {
            return false;
          }
          return previous.runtimeType != current.runtimeType;
        },
        builder: (context, state) {
          return switch (state) {
            CatalogueLoading() => const AppLoading(),
            CatalogueEmpty() => const AppEmptyState(
              title: 'No products found',
              message: 'Try another category or check back soon.',
              icon: Icons.search_off,
            ),
            CatalogueError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<CatalogueCubit>().load(),
            ),
            CatalogueLoaded() => const _CatalogueScaffold(),
          };
        },
      ),
    );
  }
}

class _CatalogueScaffold extends StatelessWidget {
  const _CatalogueScaffold();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('shop-scroll'),
      slivers: [
        SliverPadding(
          padding: context.figPagePadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              const _SearchRow(),
              SizedBox(height: context.s(16)),
              const _CategoryStrip(),
              SizedBox(height: context.s(16)),
              const _FeaturedPiece(),
              SizedBox(height: context.s(20)),
              const _CatalogueSections(),
              SizedBox(height: context.s(8)),
              const Divider(height: 1, color: AppColors.line),
              _ShopLink(
                icon: CupertinoIcons.chat_bubble,
                title: 'Enquire about custom furniture',
                detail: 'A quotation, not an order',
                onTap: () => context.push('/enquiry'),
              ),
              const Divider(height: 1, color: AppColors.line),
              _ShopLink(
                icon: CupertinoIcons.square_stack_3d_up,
                title: 'Explore the RAK sales kit',
                detail: 'Featured work and materials',
                onTap: () => context.push('/sales-kit'),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.watchCartCount});

  final Stream<int> Function() watchCartCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.s(24),
        context.s(context.figHeightConstrained ? 12 : 20),
        context.s(24),
        context.s(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText('Hi!', style: AppText.heading),
                SizedBox(height: context.s(4)),
                FigText(
                  'Which product do you want to buy?',
                  style: AppText.body,
                  color: AppColors.muted,
                ),
                SizedBox(height: context.s(4)),
                GestureDetector(
                  onTap: () => context.push('/shop/branch'),
                  child: BlocBuilder<ShopBranchCubit, ShopBranch>(
                    bloc: sl<ShopBranchCubit>(),
                    builder: (context, branch) {
                      return FigText(
                        branch.label,
                        style: AppText.caption,
                        color: AppColors.accent,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.s(12)),
          _CartButton(watchCartCount: watchCartCount),
        ],
      ),
    );
  }
}

class _CartButton extends StatefulWidget {
  const _CartButton({required this.watchCartCount});

  final Stream<int> Function() watchCartCount;

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> {
  int _count = 0;
  GoRouter? _router;
  StreamSubscription<int>? _cartCount;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (!identical(_router, router)) {
      _router?.routerDelegate.removeListener(_followCart);
      _router = router;
      router.routerDelegate.addListener(_followCart);
      _followCart();
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_followCart);
    _cartCount?.cancel();
    super.dispose();
  }

  void _followCart() {
    _cartCount?.cancel();
    _cartCount = widget.watchCartCount().listen((count) {
      if (!mounted || count == _count) return;
      setState(() => _count = count);
    });
  }

  @override
  Widget build(BuildContext context) {
    final badge = context.s(16);
    return Semantics(
      button: true,
      label: 'Cart, $_count',
      excludeSemantics: true,
      child: IconButton(
        tooltip: 'Cart',
        onPressed: () => context.go('/cart'),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tight(Size.square(context.s(44))),
        icon: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: context.s(44),
              height: context.s(44),
              decoration: const BoxDecoration(
                color: AppColors.soft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.cart,
                color: AppColors.accent,
                size: context.s(20),
              ),
            ),
            Positioned(
              right: -context.s(2),
              top: -context.s(2),
              child: Container(
                constraints: BoxConstraints(minWidth: badge, minHeight: badge),
                padding: EdgeInsets.symmetric(horizontal: context.s(4)),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(badge),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$_count',
                  style: AppText.caption2.copyWith(
                    color: AppColors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopLink extends StatelessWidget {
  const _ShopLink({
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

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => context.push('/shop/search'),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.s(10)),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        size: context.s(16),
                        color: AppColors.muted,
                      ),
                      SizedBox(width: context.s(8)),
                      const FigText(
                        'Search furniture',
                        style: AppText.caption,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => context.push('/shop/filters'),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.s(10),
                  horizontal: context.s(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.slider_horizontal_3,
                      size: context.s(16),
                      color: AppColors.ink,
                    ),
                    SizedBox(width: context.s(6)),
                    const FigText('Filter', style: AppText.label),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: FigText(title, style: AppText.title)),
        GestureDetector(
          onTap: onViewAll,
          child: FigText(
            'View all',
            style: AppText.caption,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CatalogueCubit, CatalogueState, String?>(
      selector: (state) =>
          state is CatalogueLoaded ? state.selectedCategoryId : null,
      builder: (context, selectedCategoryId) {
        final loaded = context.read<CatalogueCubit>().state;
        if (loaded is! CatalogueLoaded) return const SizedBox.shrink();
        final tabs = [
          _CategoryTab(
            label: 'All',
            selected: selectedCategoryId == null,
            onTap: () => context.read<CatalogueCubit>().selectCategory(null),
          ),
          ...loaded.categories.map(
            (category) => _CategoryTab(
              label: category.name,
              selected: selectedCategoryId == category.id,
              onTap: () =>
                  context.read<CatalogueCubit>().selectCategory(category.id),
            ),
          ),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  key: const PageStorageKey('shop-categories'),
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: tabs,
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
        );
      },
    );
  }
}

class _FeaturedPiece extends StatelessWidget {
  const _FeaturedPiece();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CatalogueCubit, CatalogueState, String?>(
      selector: (state) =>
          state is CatalogueLoaded ? state.selectedCategoryId : null,
      builder: (context, _) {
        final loaded = context.read<CatalogueCubit>().state;
        if (loaded is! CatalogueLoaded || loaded.products.isEmpty) {
          return const SizedBox.shrink();
        }
        final product = loaded.products.first;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.s(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.s(AppRadii.card)),
            boxShadow: AppDecorations.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.s(16)),
                child: SizedBox(
                  height: context.s(220),
                  width: double.infinity,
                  child: ProductArtwork(
                    imageHint: product.imageHint,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: context.s(12)),
              const _PagerDots(count: 3, index: 0),
              SizedBox(height: context.s(12)),
              FigText('Modern pieces\nfor your home', style: AppText.heading),
              SizedBox(height: context.s(8)),
              FigText(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.body,
                color: AppColors.muted,
              ),
              SizedBox(height: context.s(12)),
              Align(
                alignment: Alignment.centerRight,
                child: RakButton(
                  label: 'Get now',
                  width: 140,
                  height: 44,
                  onPressed: () => context.push('/shop/products/${product.id}'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PagerDots extends StatelessWidget {
  const _PagerDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(width: context.s(6)),
          Container(
            width: context.s(i == index ? 16 : 6),
            height: context.s(6),
            decoration: BoxDecoration(
              color: i == index ? AppColors.accent : AppColors.line,
              borderRadius: BorderRadius.circular(context.s(6)),
            ),
          ),
        ],
      ],
    );
  }
}

class _CatalogueSections extends StatelessWidget {
  const _CatalogueSections();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CatalogueCubit, CatalogueState, String?>(
      selector: (state) =>
          state is CatalogueLoaded ? state.selectedCategoryId : null,
      builder: (context, selectedCategoryId) {
        final loaded = context.read<CatalogueCubit>().state;
        if (loaded is! CatalogueLoaded) return const SizedBox.shrink();
        final products = loaded.products;
        if (products.isEmpty) {
          return Text(
            'Nothing in this category yet.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          );
        }
        final split = products.length > 2;
        final arrivals = split
            ? products.take(2).toList()
            : const <CatalogueProduct>[];
        final popular = split ? products.sublist(2) : products;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (split) ...[
              _SectionHeader(
                title: 'New arrival',
                onViewAll: () =>
                    context.read<CatalogueCubit>().selectCategory(null),
              ),
              SizedBox(height: context.s(12)),
              SizedBox(
                height: context.productCardExtent,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: arrivals.length,
                  separatorBuilder: (_, _) => SizedBox(width: context.s(12)),
                  itemBuilder: (context, index) {
                    final product = arrivals[index];
                    return SizedBox(
                      width: context.s(AppLayout.productCardWidth),
                      child: ProductCard(
                        key: ValueKey('arrival-${product.id}'),
                        product: product,
                        onTap: () =>
                            context.push('/shop/products/${product.id}'),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: context.s(20)),
            ],
            _SectionHeader(
              title: 'Popular',
              onViewAll: () => context.push('/shop/filters'),
            ),
            SizedBox(height: context.s(12)),
            _ProductGrid(products: popular, categoryKey: selectedCategoryId),
          ],
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products, required this.categoryKey});

  final List<CatalogueProduct> products;
  final String? categoryKey;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: ValueKey(categoryKey),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.productCrossAxisCount,
        mainAxisSpacing: context.s(AppLayout.productGap),
        crossAxisSpacing: context.s(AppLayout.productGap),
        mainAxisExtent: context.productCardExtent,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          key: ValueKey(product.id),
          product: product,
          onTap: () => context.push('/shop/products/${product.id}'),
        );
      },
    );
  }
}

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: context.s(4), right: context.s(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FigText(
              label,
              style: AppText.label,
              color: selected ? AppColors.ink : AppColors.muted,
            ),
            SizedBox(height: context.s(8)),
            SizedBox(
              height: context.s(2),
              width: context.s(18),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? AppColors.ink : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _availabilityLabel(CatalogueProduct product) {
  return switch (product.salesMode) {
    SalesMode.fixedPrice => 'In stock',
    SalesMode.madeToOrder => 'Made to order',
    SalesMode.quotationOnly => 'Quote only',
  };
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final CatalogueProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppRadii.card);
    final price = product.priceMinor == null
        ? 'Quote only'
        : MoneyFormatter.format(
            Money(minorUnits: product.priceMinor!, currency: product.currency),
          );
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: context.s(AppLayout.productArtHeight),
                  width: double.infinity,
                  child: ProductArtwork(
                    imageHint: product.imageHint,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: context.s(8),
                  right: context.s(8),
                  child: _SaveControl(productId: product.id),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(12),
                context.s(10),
                context.s(12),
                context.s(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18 * MediaQuery.textScalerOf(context).scale(1) * 2,
                    child: FigText(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label,
                    ),
                  ),
                  SizedBox(height: context.s(8)),
                  FigText(price, style: AppText.label),
                  SizedBox(height: context.s(2)),
                  FigText(
                    _availabilityLabel(product),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                    color: product.canAddToCart
                        ? AppColors.accent
                        : AppColors.muted,
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

class _SaveControl extends StatelessWidget {
  const _SaveControl({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavouritesCubit, Set<String>, bool>(
      selector: (ids) => ids.contains(productId),
      builder: (context, saved) {
        return Material(
          color: AppColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.read<FavouritesCubit>().toggle(productId),
            child: SizedBox(
              width: context.s(32),
              height: context.s(32),
              child: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? AppColors.logoRed : AppColors.muted,
                size: context.s(18),
              ),
            ),
          ),
        );
      },
    );
  }
}
