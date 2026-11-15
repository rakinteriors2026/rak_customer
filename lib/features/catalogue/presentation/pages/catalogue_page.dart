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
              SizedBox(height: context.s(12)),
              const _CategoryStrip(),
              SizedBox(height: context.s(16)),
              const _EditorialBanner(),
              SizedBox(height: context.s(20)),
              const _CatalogueSections(),
              SizedBox(height: context.s(28)),
              const _BespokeAndARServices(),
              SizedBox(height: context.s(16)),
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
        context.s(context.figHeightConstrained ? 8 : 14),
        context.s(20),
        context.s(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FigText('Shop', style: AppText.heading),
                SizedBox(height: context.s(4)),
                GestureDetector(
                  onTap: () => context.push('/shop/branch'),
                  child: BlocBuilder<ShopBranchCubit, ShopBranch>(
                    bloc: sl<ShopBranchCubit>(),
                    builder: (context, branch) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.s(8),
                          vertical: context.s(3),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: BorderRadius.circular(context.s(6)),
                          border: Border.all(
                            color: AppColors.line.withOpacity(0.8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              size: context.s(11),
                              color: AppColors.brass,
                            ),
                            SizedBox(width: context.s(4)),
                            FigText(
                              '${branch.label} Showroom',
                              style: AppText.caption.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              color: AppColors.ink,
                            ),
                            SizedBox(width: context.s(2)),
                            Icon(
                              CupertinoIcons.chevron_down,
                              size: context.s(9),
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: context.s(8)),
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
                color: AppColors.canvas,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.bag,
                color: AppColors.ink,
                size: context.s(20),
              ),
            ),
            if (_count > 0)
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
                      fontWeight: FontWeight.w600,
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

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(context.s(12)),
        border: Border.all(color: AppColors.line.withOpacity(0.7)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => context.push('/shop/search'),
              borderRadius: BorderRadius.circular(context.s(12)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.s(14),
                  vertical: context.s(11),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      size: context.s(16),
                      color: AppColors.muted,
                    ),
                    SizedBox(width: context.s(10)),
                    const Expanded(
                      child: FigText(
                        'Search furniture, lighting, decor…',
                        style: AppText.caption,
                        color: AppColors.muted,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: context.s(20),
            color: AppColors.line,
          ),
          InkWell(
            onTap: () => context.push('/shop/filters'),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(context.s(12)),
              bottomRight: Radius.circular(context.s(12)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.s(14),
                vertical: context.s(11),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.slider_horizontal_3,
                    size: context.s(15),
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
          _CategoryChip(
            label: 'All',
            selected: selectedCategoryId == null,
            onTap: () => context.read<CatalogueCubit>().selectCategory(null),
          ),
          ...loaded.categories.map(
            (category) => _CategoryChip(
              label: category.name,
              selected: selectedCategoryId == category.id,
              onTap: () =>
                  context.read<CatalogueCubit>().selectCategory(category.id),
            ),
          ),
        ];
        return SingleChildScrollView(
          key: const PageStorageKey('shop-categories'),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tabs
                .expand((t) => [t, SizedBox(width: context.s(8))])
                .toList(),
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.s(16),
          vertical: context.s(8),
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.canvas,
          borderRadius: BorderRadius.circular(context.s(20)),
          border: Border.all(
            color: selected ? AppColors.ink : AppColors.line.withOpacity(0.8),
          ),
        ),
        child: FigText(
          label,
          style: AppText.caption.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
          color: selected ? AppColors.white : AppColors.ink,
        ),
      ),
    );
  }
}

/// Curated editorial hero banner for high-end aesthetics
class _EditorialBanner extends StatelessWidget {
  const _EditorialBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.s(145),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(context.s(16)),
        image: const DecorationImage(
          image: AssetImage('assets/showcase/show_minimal_cover.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Gradient scrim for text readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.78),
                    Colors.black.withOpacity(0.35),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: context.s(18),
            top: context.s(18),
            bottom: context.s(18),
            right: context.s(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.s(8),
                    vertical: context.s(3),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brass.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(context.s(4)),
                  ),
                  child: Text(
                    'CURATED LIVING',
                    style: AppText.caption2.copyWith(
                      color: AppColors.white,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: context.s(6)),
                Text(
                  'The Minimalist Edit',
                  style: AppText.screenTitle.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: context.s(2)),
                Text(
                  'European oak, spun brass & pure linen.',
                  style: AppText.caption.copyWith(
                    color: AppColors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
          return const AppEmptyState(
            title: 'Nothing in this category',
            message: 'Try another category or explore all pieces.',
            icon: Icons.chair_outlined,
          );
        }

        final categoryTitle = selectedCategoryId == null
            ? 'All Pieces'
            : loaded.categories
                .firstWhere(
                  (c) => c.id == selectedCategoryId,
                  orElse: () => const CatalogueCategory(id: '', name: 'Pieces'),
                )
                .name;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FigText(categoryTitle, style: AppText.title),
                    SizedBox(width: context.s(6)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.s(7),
                        vertical: context.s(2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(context.s(10)),
                      ),
                      child: Text(
                        '${products.length}',
                        style: AppText.caption2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.push('/shop/filters'),
                  child: Row(
                    children: [
                      Text(
                        'Sort & Filter',
                        style: AppText.caption.copyWith(
                          color: AppColors.brass,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: context.s(2)),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: context.s(11),
                        color: AppColors.brass,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.s(14)),
            _ProductGrid(
              products: products,
              categoryKey: selectedCategoryId,
            ),
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
        mainAxisSpacing: context.s(14),
        crossAxisSpacing: context.s(14),
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

String _availabilityLabel(CatalogueProduct product) {
  return switch (product.salesMode) {
    SalesMode.fixedPrice => 'Ready stock',
    SalesMode.madeToOrder => 'Made to order',
    SalesMode.quotationOnly => 'Bespoke',
  };
}

String _productMaterial(CatalogueProduct product) {
  return switch (product.id) {
    'prod_oak_table' => 'Solid European Oak · Natural Oil',
    'prod_linen_sofa' => 'Natural Linen · Hardwood Frame',
    'prod_brass_pendant' => 'Hand-spun Solid Brass',
    'prod_wardrobe' => 'Bespoke Oak / Matte Lacquer',
    'prod_rug' => '100% New Zealand Wool',
    _ => product.specs.contains('oak')
        ? 'Solid Oak Finish'
        : 'Premium Architectural Finish',
  };
}

String _deliveryHint(CatalogueProduct product) {
  return switch (product.salesMode) {
    SalesMode.fixedPrice => 'Delivers in 3–5 days',
    SalesMode.madeToOrder => 'Made to order · 2–3 weeks',
    SalesMode.quotationOnly => 'Custom lead time on site survey',
  };
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final CatalogueProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(14.0);
    final isQuoteOnly =
        product.salesMode == SalesMode.quotationOnly ||
        product.priceMinor == null;
    final price = product.priceMinor == null
        ? 'Quote on request'
        : MoneyFormatter.format(
            Money(minorUnits: product.priceMinor!, currency: product.currency),
          );

    final badgeLabel = _availabilityLabel(product);

    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: AppColors.line.withOpacity(0.65)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Image Container ───
            Stack(
              children: [
                Container(
                  height: context.s(140.0),
                  width: double.infinity,
                  color: AppColors.canvas,
                  child: ProductArtwork(
                    imageHint: product.imageHint,
                    imageUrl: product.primaryImageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                // Top-left status badge
                Positioned(
                  top: context.s(8),
                  left: context.s(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.s(6),
                      vertical: context.s(2.5),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(context.s(4)),
                    ),
                    child: Text(
                      badgeLabel.toUpperCase(),
                      style: AppText.caption2.copyWith(
                        fontSize: 9,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600,
                        color: product.canAddToCart
                            ? AppColors.ink
                            : AppColors.brass,
                      ),
                    ),
                  ),
                ),
                // Top-right save heart
                Positioned(
                  top: context.s(6),
                  right: context.s(6),
                  child: _SaveControl(productId: product.id),
                ),
              ],
            ),
            // ─── Content ───
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(10),
                context.s(8),
                context.s(10),
                context.s(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  SizedBox(
                    height: 18 * MediaQuery.textScalerOf(context).scale(1) * 2,
                    child: FigText(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(height: context.s(3)),
                  // Material or finish
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.sparkles,
                        size: context.s(10),
                        color: AppColors.brass,
                      ),
                      SizedBox(width: context.s(3)),
                      Expanded(
                        child: Text(
                          _productMaterial(product),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.caption2.copyWith(
                            color: AppColors.ink,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.s(3)),
                  // Specs/Dimension line & Delivery hint
                  Text(
                    '${product.specs} · ${_deliveryHint(product)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption2.copyWith(
                      color: AppColors.muted,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: context.s(6)),
                  // Price and CTA / Request Quote
                  if (isQuoteOnly)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => context.push(
                              '/enquiry?productId=${product.id}',
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.s(8),
                                vertical: context.s(5),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.brass,
                                borderRadius: BorderRadius.circular(
                                  context.s(6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.doc_text,
                                    size: context.s(11),
                                    color: AppColors.white,
                                  ),
                                  SizedBox(width: context.s(4)),
                                  Text(
                                    'Request quote',
                                    style: AppText.caption2.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.label.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        Container(
                          width: context.s(24),
                          height: context.s(24),
                          decoration: BoxDecoration(
                            color: AppColors.canvas,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.arrow_right,
                            size: context.s(11),
                            color: AppColors.ink,
                          ),
                        ),
                      ],
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
          color: AppColors.surface.withOpacity(0.92),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.read<FavouritesCubit>().toggle(productId),
            child: SizedBox(
              width: context.s(28),
              height: context.s(28),
              child: Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? AppColors.logoRed : AppColors.muted,
                size: context.s(15),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Rich, editorial cards for bespoke joinery and material studio
class _BespokeAndARServices extends StatelessWidget {
  const _BespokeAndARServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Furniture Banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.s(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.s(14)),
            border: Border.all(color: AppColors.line.withOpacity(0.7)),
          ),
          child: Row(
            children: [
              Container(
                width: context.s(44),
                height: context.s(44),
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(context.s(10)),
                ),
                child: Icon(
                  CupertinoIcons.pencil_outline,
                  color: AppColors.brass,
                  size: context.s(20),
                ),
              ),
              SizedBox(width: context.s(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FigText(
                      'Bespoke & Custom Furniture',
                      style: AppText.label,
                    ),
                    SizedBox(height: context.s(2)),
                    FigText(
                      'Get custom joinery sized to your room dimensions.',
                      style: AppText.caption,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.s(8)),
              InkWell(
                onTap: () => context.push('/enquiry'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.s(12),
                    vertical: context.s(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(context.s(8)),
                  ),
                  child: Text(
                    'Enquire',
                    style: AppText.caption2.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.s(12)),
        // Sales Kit Banner
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.s(16)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(context.s(14)),
            border: Border.all(color: AppColors.line.withOpacity(0.7)),
          ),
          child: Row(
            children: [
              Container(
                width: context.s(44),
                height: context.s(44),
                decoration: BoxDecoration(
                  color: AppColors.soft,
                  borderRadius: BorderRadius.circular(context.s(10)),
                ),
                child: Icon(
                  CupertinoIcons.square_stack_3d_up,
                  color: AppColors.ink,
                  size: context.s(20),
                ),
              ),
              SizedBox(width: context.s(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FigText(
                      'Materials & Finishes Catalogue',
                      style: AppText.label,
                    ),
                    SizedBox(height: context.s(2)),
                    FigText(
                      'Explore architectural finishes, veneers & swatches.',
                      style: AppText.caption,
                      color: AppColors.muted,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.s(8)),
              InkWell(
                onTap: () => context.push('/sales-kit'),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.s(12),
                    vertical: context.s(8),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(context.s(8)),
                  ),
                  child: Text(
                    'Explore',
                    style: AppText.caption2.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
