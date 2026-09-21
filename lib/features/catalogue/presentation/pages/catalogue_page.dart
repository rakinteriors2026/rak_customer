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
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogueCubit>()..load(),
      child: const _CatalogueView(),
    );
  }
}

class _CatalogueView extends StatelessWidget {
  const _CatalogueView();

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'RAK Store',
      subtitle: 'Thoughtful pieces. Beautiful spaces.',
      contentGap: 16,
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
              const _StoreShortcuts(),
              SizedBox(height: context.s(16)),
              const _SearchField(),
              SizedBox(height: context.s(16)),
              const _PromoCarousel(),
              SizedBox(height: context.s(12)),
              Text(
                'THE LIVING EDIT   /   01—02',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: context.s(16)),
              const _CategoryStrip(),
              SizedBox(height: context.s(16)),
              const _PopularPicksHeader(),
              SizedBox(height: context.s(16)),
              const _ProductGrid(),
              SizedBox(height: context.s(16)),
              Text(
                'Need something made just for you?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: context.s(12)),
              RakButton(
                label: 'Enquire about custom furniture',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/enquiry'),
              ),
              SizedBox(height: context.s(12)),
              RakButton(
                label: 'Explore the RAK sales kit',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/sales-kit'),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _StoreShortcuts extends StatelessWidget {
  const _StoreShortcuts();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.s(AppLayout.tapTarget),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/shop/branch'),
              behavior: HitTestBehavior.opaque,
              child: Align(
                alignment: Alignment.centerLeft,
                child: BlocBuilder<ShopBranchCubit, ShopBranch>(
                  bloc: sl<ShopBranchCubit>(),
                  builder: (context, branch) {
                    return FigText(branch.label, style: AppText.caption);
                  },
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/favourites'),
            child: SizedBox(
              width: context.s(64),
              height: context.s(AppLayout.tapTarget),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FigText(
                  '♡ Saved',
                  style: AppText.caption,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
          SizedBox(width: context.s(12)),
          GestureDetector(
            onTap: () => context.push('/cart'),
            child: SizedBox(
              width: context.s(44),
              height: context.s(AppLayout.tapTarget),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FigText(
                  'Bag',
                  style: AppText.caption,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: InputDecorator(
        decoration: const InputDecoration(
          hintText: 'Search furniture & home accents',
        ),
        child: Text(
          'Search furniture & home accents',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  const _PromoCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.s(AppLayout.promoCarouselHeight),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _PromoCard(
              eyebrow: 'THE LIVING EDIT',
              title: 'Considered comfort',
              cta: 'Explore seating →',
              accent: true,
              onTap: () => context.read<CatalogueCubit>().selectCategory(
                'cat_furniture',
              ),
            ),
          ),
          SizedBox(width: context.s(12)),
          Align(
            alignment: Alignment.topLeft,
            child: _PromoCard(
              eyebrow: 'THE FINISHING TOUCH',
              title: 'Small details. Big difference.',
              cta: 'Discover home accents →',
              accent: false,
              onTap: () =>
                  context.read<CatalogueCubit>().selectCategory('cat_decor'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularPicksHeader extends StatelessWidget {
  const _PopularPicksHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.s(AppLayout.tapTarget),
      child: Row(
        children: [
          Expanded(
            child: FigText(
              'Popular picks',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.title,
            ),
          ),
          SizedBox(width: context.s(12)),
          GestureDetector(
            onTap: () => context.push('/filters'),
            child: SizedBox(
              width: context.s(130),
              height: context.s(AppLayout.tapTarget),
              child: Align(
                alignment: Alignment.centerRight,
                child: FigText(
                  'Filter & sort',
                  style: AppText.caption,
                  color: AppColors.accent,
                ),
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
        return SizedBox(
          height: context.s(AppLayout.tapTarget),
          child: ListView(
            key: const PageStorageKey('shop-categories'),
            scrollDirection: Axis.horizontal,
            children: [
              _CategoryChip(
                label: 'All',
                selected: selectedCategoryId == null,
                onTap: () =>
                    context.read<CatalogueCubit>().selectCategory(null),
              ),
              ...loaded.categories.map(
                (category) => _CategoryChip(
                  label: category.name,
                  selected: selectedCategoryId == category.id,
                  onTap: () => context.read<CatalogueCubit>().selectCategory(
                    category.id,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

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
        return GridView.builder(
          key: ValueKey(selectedCategoryId),
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
    return Padding(
      padding: EdgeInsets.only(right: context.s(16)),
      child: SizedBox(
        height: context.s(AppLayout.tapTarget),
        child: GestureDetector(
          onTap: onTap,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FigText(
              label,
              style: selected
                  ? AppText.label
                  : AppText.body.copyWith(color: AppColors.muted),
            ),
          ),
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({
    required this.eyebrow,
    required this.title,
    required this.cta,
    required this.accent,
    required this.onTap,
  });

  final String eyebrow;
  final String title;
  final String cta;
  final bool accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppRadii.button);
    return Material(
      color: accent ? AppColors.accent : AppColors.sand,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: accent
            ? AppColors.white.withValues(alpha: 0.12)
            : AppColors.accent.withValues(alpha: 0.10),
        highlightColor: accent
            ? AppColors.white.withValues(alpha: 0.06)
            : AppColors.accent.withValues(alpha: 0.05),
        child: SizedBox(
          width: context.s(AppLayout.promoWidth),
          height: context.s(AppLayout.promoHeight),
          child: Padding(
            padding: EdgeInsets.all(context.s(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText(
                  eyebrow,
                  style: AppText.caption,
                  color: accent ? AppColors.white : AppColors.accent,
                ),
                SizedBox(height: context.s(8)),
                FigText(
                  title,
                  style: AppText.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: accent ? AppColors.white : AppColors.ink,
                ),
                SizedBox(height: context.s(8)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FigText(
                      cta,
                      style: AppText.label,
                      color: accent ? AppColors.white : AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final CatalogueProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppLayout.productRadius);
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.accent.withValues(alpha: 0.10),
        highlightColor: AppColors.accent.withValues(alpha: 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.s(AppLayout.productArtHeight),
              width: double.infinity,
              child: ProductArtwork(
                imageHint: product.imageHint,
                width: double.infinity,
                height: context.s(AppLayout.productArtHeight),
              ),
            ),
            SizedBox(height: context.s(8)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.s(12),
                  context.s(12),
                  context.s(12),
                  context.s(24),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FigText(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.label,
                            ),
                            SizedBox(height: context.s(4)),
                            FigText(
                              product.priceMinor == null
                                  ? 'Quote only'
                                  : MoneyFormatter.format(
                                      Money(
                                        minorUnits: product.priceMinor!,
                                        currency: product.currency,
                                      ),
                                    ),
                              style: AppText.label,
                            ),
                            SizedBox(height: context.s(4)),
                            FigText(
                              product.canAddToCart
                                  ? 'In stock'
                                  : 'Made to order',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.caption,
                              color: product.canAddToCart
                                  ? AppColors.success
                                  : AppColors.muted,
                            ),
                            SizedBox(height: context.s(4)),
                            _SaveControl(productId: product.id),
                            FigText(
                              'View product →',
                              style: AppText.caption,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        return SizedBox(
          height: context.s(AppLayout.tapTarget) * textScale.clamp(1.0, 3.0),
          width: double.infinity,
          child: InkWell(
            onTap: () => context.read<FavouritesCubit>().toggle(productId),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FigText(
                saved ? '♥ Saved' : '♡ Save',
                style: AppText.caption,
                color: AppColors.accent,
              ),
            ),
          ),
        );
      },
    );
  }
}
