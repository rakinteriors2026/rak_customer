import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/core/domain/entities/home_project_progress.dart';
import 'package:rak_customer/core/domain/entities/home_service_item.dart';
import 'package:rak_customer/core/domain/entities/home_showcase_item.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/home_project_repository.dart';
import 'package:rak_customer/core/domain/repositories/home_service_repository.dart';
import 'package:rak_customer/core/domain/repositories/home_showcase_repository.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/product_artwork.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';
import 'package:rak_customer/shared/widgets/rak_progress_bar.dart';

/// Minimal, high-end editorial storefront & interior progress home.
class ShopHomePage extends StatelessWidget {
  const ShopHomePage({super.key, required this.interiorAccounts});

  final Stream<Account?> interiorAccounts;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      header: const _HomeHeader(),
      contentGap: 4,
      child: _ShopHomeBody(interiorAccounts: interiorAccounts),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.s(24),
        context.s(context.figHeightConstrained ? 8 : 14),
        context.s(24),
        context.s(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'RAK',
                    style: AppText.heading.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.ink,
                    ),
                  ),
                  SizedBox(width: context.s(6)),
                  Text(
                    'INTERIORS',
                    style: AppText.title.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2.0,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.s(3)),
              GestureDetector(
                onTap: () => context.push('/shop/branch'),
                child: BlocBuilder<ShopBranchCubit, ShopBranch>(
                  bloc: sl<ShopBranchCubit>(),
                  builder: (context, branch) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.s(7),
                        vertical: context.s(2.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(context.s(6)),
                        border: Border.all(
                          color: AppColors.line.withOpacity(0.85),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.location_solid,
                            size: context.s(10),
                            color: AppColors.brass,
                          ),
                          SizedBox(width: context.s(3)),
                          Text(
                            'Branch: ${branch.name}',
                            style: AppText.caption2.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(width: context.s(3)),
                          Icon(
                            CupertinoIcons.chevron_down,
                            size: context.s(8.5),
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
          IconButton(
            onPressed: () => context.go('/account'),
            tooltip: 'Account',
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(Size.square(context.s(40))),
            icon: Container(
              width: context.s(38),
              height: context.s(38),
              decoration: const BoxDecoration(
                color: AppColors.canvas,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.person,
                size: context.s(18),
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopHomeBody extends StatelessWidget {
  const _ShopHomeBody({required this.interiorAccounts});

  final Stream<Account?> interiorAccounts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: context.figPagePadding,
      children: [
        // ─── Editorial Hero with Primary CTA ───
        const _EditorialHomeHero(),
        SizedBox(height: context.s(16)),

        // ─── 12,400+ Trust Bar ───
        const _TrustGuaranteeBar(),
        SizedBox(height: context.s(18)),

        // ─── Quick Discovery Pills (Free Quote, Residences, Services, Finishes) ───
        const _QuickExplorePills(),
        SizedBox(height: context.s(22)),

        // ─── Offer / Consultation Banner ───
        const _DesignOfferBanner(),
        SizedBox(height: context.s(24)),

        // ─── Customer Project Status (if linked) ───
        _InteriorWork(accounts: interiorAccounts),

        // ─── Featured Showcase Work (Finished Residences) ───
        const _FeaturedWork(),
        SizedBox(height: context.s(28)),

        // ─── Featured Products / Furniture Rail (Replaces redundant shop row) ───
        const _FeaturedProductsSection(),
        SizedBox(height: context.s(28)),

        // ─── Services ───
        const _Services(),
        SizedBox(height: context.s(28)),

        // ─── Consultation Banner ───
        const _ConsultationCard(),
        SizedBox(height: context.s(20)),
      ],
    );
  }
}

/// Trust and milestone badge for 12,400+ homes
class _TrustGuaranteeBar extends StatelessWidget {
  const _TrustGuaranteeBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.s(14),
        vertical: context.s(10),
      ),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(context.s(10)),
        border: Border.all(color: AppColors.line.withOpacity(0.85)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TrustItem(
            icon: CupertinoIcons.shield_fill,
            label: '10-Year Warranty',
          ),
          Container(
            height: context.s(16),
            width: 1,
            color: AppColors.line,
          ),
          _TrustItem(
            icon: CupertinoIcons.house_alt_fill,
            label: '12,400+ Homes',
          ),
          Container(
            height: context.s(16),
            width: 1,
            color: AppColors.line,
          ),
          _TrustItem(
            icon: CupertinoIcons.hammer_fill,
            label: 'Direct Factory',
          ),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.s(12), color: AppColors.brass),
        SizedBox(width: context.s(5)),
        Text(
          label,
          style: AppText.caption2.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

/// Editorial Hero Banner with inspiring photography & direct CTAs
class _EditorialHomeHero extends StatelessWidget {
  const _EditorialHomeHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.s(225),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(context.s(18)),
        image: const DecorationImage(
          image: AssetImage('assets/photos/hero_home.png'),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Gradient Scrim for deep minimal mood & high contrast
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.88),
                    Colors.black.withOpacity(0.40),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: context.s(20),
            right: context.s(20),
            bottom: context.s(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.s(8),
                    vertical: context.s(3),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brass,
                    borderRadius: BorderRadius.circular(context.s(4)),
                  ),
                  child: Text(
                    '12,400+ HOMES DELIVERED',
                    style: AppText.caption2.copyWith(
                      color: AppColors.white,
                      letterSpacing: 0.9,
                      fontWeight: FontWeight.w700,
                      fontSize: 9.5,
                    ),
                  ),
                ),
                SizedBox(height: context.s(6)),
                Text(
                  'Spaces crafted for living.',
                  style: AppText.heading.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: context.s(4)),
                Text(
                  'Kerala & Bangalore’s most trusted interior design partner.',
                  style: AppText.caption.copyWith(
                    color: AppColors.white.withOpacity(0.92),
                  ),
                ),
                SizedBox(height: context.s(12)),
                Row(
                  children: [
                    // Primary call to action near top
                    InkWell(
                      onTap: () => context.push('/enquiry'),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.s(16),
                          vertical: context.s(9),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(context.s(20)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.sparkles,
                              size: context.s(13),
                              color: AppColors.ink,
                            ),
                            SizedBox(width: context.s(6)),
                            Text(
                              'Get a Free Quote',
                              style: AppText.caption.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: context.s(10)),
                    InkWell(
                      onTap: () => context.push('/showcase'),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.s(14),
                          vertical: context.s(9),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.45),
                          ),
                          borderRadius: BorderRadius.circular(context.s(20)),
                        ),
                        child: Text(
                          'Our Work',
                          style: AppText.caption.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 4 Clean Discovery Pills
class _QuickExplorePills extends StatelessWidget {
  const _QuickExplorePills();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillTile(
            icon: CupertinoIcons.chat_bubble_text,
            label: 'Free Quote',
            onTap: () => context.push('/enquiry'),
          ),
        ),
        SizedBox(width: context.s(8)),
        Expanded(
          child: _PillTile(
            icon: CupertinoIcons.photo,
            label: 'Homes',
            onTap: () => context.push('/showcase'),
          ),
        ),
        SizedBox(width: context.s(8)),
        Expanded(
          child: _PillTile(
            icon: CupertinoIcons.sparkles,
            label: 'Services',
            onTap: () => context.push('/services'),
          ),
        ),
        SizedBox(width: context.s(8)),
        Expanded(
          child: _PillTile(
            icon: CupertinoIcons.square_stack_3d_up,
            label: 'Finishes',
            onTap: () => context.push('/sales-kit'),
          ),
        ),
      ],
    );
  }
}

class _PillTile extends StatelessWidget {
  const _PillTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.s(12)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.s(12)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.s(12)),
          border: Border.all(color: AppColors.line.withOpacity(0.7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: context.s(18), color: AppColors.ink),
            SizedBox(height: context.s(5)),
            Text(
              label,
              style: AppText.caption2.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gallery of finished RAK interiors
class _FeaturedWork extends StatefulWidget {
  const _FeaturedWork();

  @override
  State<_FeaturedWork> createState() => _FeaturedWorkState();
}

class _FeaturedWorkState extends State<_FeaturedWork> {
  late final Future<List<HomeShowcaseItem>> _items;

  @override
  void initState() {
    super.initState();
    _items = sl<HomeShowcaseRepository>().featured();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomeShowcaseItem>>(
      future: _items,
      builder: (context, snapshot) {
        final items = snapshot.data;
        if (items == null || items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Finished Residences',
              actionLabel: 'View all',
              onAction: () => context.push('/showcase'),
            ),
            SizedBox(height: context.s(2)),
            const FigText(
              'Curated living spaces crafted across Kerala & UAE.',
              style: AppText.caption,
              color: AppColors.muted,
            ),
            SizedBox(height: context.s(14)),
            SizedBox(
              height: context.s(185),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, _) => SizedBox(width: context.s(14)),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: context.s(260),
                    child: _ShowcaseCard(
                      item: item,
                      onTap: () => context.push('/showcase/${item.id}'),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({required this.item, required this.onTap});

  final HomeShowcaseItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(14.0);
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: AppColors.line.withOpacity(0.7)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RakPhoto(asset: item.coverAsset, height: 130, radius: 0),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(12),
                context.s(10),
                context.s(12),
                context.s(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.s(2)),
                  FigText(
                    '${item.styleLabel} · ${item.locationLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                    color: AppColors.muted,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: FigText(title, style: AppText.screenTitle)),
        if (actionLabel != null && onAction != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(context.s(8)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.s(4),
                vertical: context.s(2),
              ),
              child: Row(
                children: [
                  FigText(
                    actionLabel!,
                    style: AppText.caption.copyWith(
                      color: AppColors.brass,
                      fontWeight: FontWeight.w600,
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
          ),
      ],
    );
  }
}

/// Offer and trust banner on Home
class _DesignOfferBanner extends StatelessWidget {
  const _DesignOfferBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.s(16)),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(context.s(14)),
        border: Border.all(color: AppColors.brass.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: context.s(42),
            height: context.s(42),
            decoration: BoxDecoration(
              color: AppColors.brass.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.sparkles,
              color: AppColors.brass,
              size: context.s(20),
            ),
          ),
          SizedBox(width: context.s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COMPLIMENTARY CONSULTATION',
                  style: AppText.caption2.copyWith(
                    color: AppColors.brass,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    fontSize: 9,
                  ),
                ),
                SizedBox(height: context.s(2)),
                FigText(
                  'Free 3D Layout & Estimate',
                  style: AppText.label.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: context.s(2)),
                const FigText(
                  'Review floor-plans with senior architects across Kerala & Bangalore.',
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
                color: AppColors.brass,
                borderRadius: BorderRadius.circular(context.s(8)),
              ),
              child: Text(
                'Book',
                style: AppText.caption2.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Featured Products rail replacing the duplicate shop row on Home
class _FeaturedProductsSection extends StatelessWidget {
  const _FeaturedProductsSection();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogueCubit>()..load(),
      child: BlocBuilder<CatalogueCubit, CatalogueState>(
        builder: (context, state) {
          if (state is! CatalogueLoaded) return const SizedBox.shrink();
          final products = state.products.take(5).toList();
          if (products.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                title: 'Featured Furniture',
                actionLabel: 'View collection',
                onAction: () => context.go('/shop'),
              ),
              SizedBox(height: context.s(2)),
              const FigText(
                'Signature solid wood & made-to-order living pieces.',
                style: AppText.caption,
                color: AppColors.muted,
              ),
              SizedBox(height: context.s(14)),
              SizedBox(
                height: context.s(185),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemCount: products.length,
                  separatorBuilder: (_, _) => SizedBox(width: context.s(12)),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return SizedBox(
                      width: context.s(170),
                      child: _FeaturedProductTile(
                        product: product,
                        onTap: () =>
                            context.push('/shop/products/${product.id}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FeaturedProductTile extends StatelessWidget {
  const _FeaturedProductTile({
    required this.product,
    required this.onTap,
  });

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

    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: AppColors.line.withOpacity(0.7)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: context.s(110),
              width: double.infinity,
              color: AppColors.canvas,
              child: ProductArtwork(
                imageHint: product.imageHint,
                imageUrl: product.primaryImageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(10),
                context.s(8),
                context.s(10),
                context.s(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                  SizedBox(height: context.s(2)),
                  Text(
                    product.specs,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption2.copyWith(
                      color: AppColors.muted,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: context.s(6)),
                  if (isQuoteOnly)
                    Text(
                      'Request quote',
                      style: AppText.caption2.copyWith(
                        color: AppColors.brass,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    Text(
                      price,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
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

/// Horizontal rail of RAK services
class _Services extends StatefulWidget {
  const _Services();

  @override
  State<_Services> createState() => _ServicesState();
}

class _ServicesState extends State<_Services> {
  late final Future<List<HomeServiceItem>> _items;

  @override
  void initState() {
    super.initState();
    _items = sl<HomeServiceRepository>().featured();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HomeServiceItem>>(
      future: _items,
      builder: (context, snapshot) {
        final items = snapshot.data;
        if (items == null || items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Interior Expertise',
              actionLabel: 'View all',
              onAction: () => context.push('/services'),
            ),
            SizedBox(height: context.s(2)),
            const FigText(
              'Turnkey design and factory craftsmanship under one roof.',
              style: AppText.caption,
              color: AppColors.muted,
            ),
            SizedBox(height: context.s(14)),
            SizedBox(
              height: context.s(176),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                itemCount: items.length,
                separatorBuilder: (_, _) => SizedBox(width: context.s(12)),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: context.s(195),
                    child: _ServiceTile(
                      item: item,
                      onTap: () => context.push('/services/${item.id}'),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.item, required this.onTap});

  final HomeServiceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(14.0);
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: AppColors.line.withOpacity(0.7)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RakPhoto(asset: item.heroAsset, height: 95, radius: 0),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.s(12),
                context.s(8),
                context.s(12),
                context.s(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: context.s(2)),
                  FigText(
                    item.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.caption,
                    color: AppColors.muted,
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
        return _InteriorProjects(
          key: ValueKey(account.id),
          accountId: account.id,
        );
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
        if (projects == null || projects.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FigText('Your Interior Project', style: AppText.screenTitle),
            SizedBox(height: context.s(10)),
            for (var i = 0; i < projects.length; i++) ...[
              _ProjectCard(project: projects[i]),
              if (i < projects.length - 1) SizedBox(height: context.s(12)),
            ],
            SizedBox(height: context.s(24)),
          ],
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final HomeProjectProgress project;

  @override
  Widget build(BuildContext context) {
    final percent = project.progressPercent;
    return Container(
      padding: EdgeInsets.all(context.s(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.s(14)),
        border: Border.all(color: AppColors.line.withOpacity(0.8)),
      ),
      child: InkWell(
        onTap: () => context.push('/projects'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FigText(
                        project.name,
                        style: AppText.label.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.s(2)),
                      FigText(
                        '${project.phaseLabel} · ${project.siteLabel}',
                        style: AppText.caption,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.s(8),
                    vertical: context.s(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(context.s(6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Track',
                        style: AppText.caption2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(width: context.s(2)),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: context.s(10),
                        color: AppColors.ink,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (percent != null) ...[
              SizedBox(height: context.s(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FigText(
                    'Overall Progress',
                    style: AppText.caption,
                    color: AppColors.muted,
                  ),
                  FigText(
                    '$percent%',
                    style: AppText.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.s(6)),
              RakProgressBar(value: percent / 100),
            ],
          ],
        ),
      ),
    );
  }
}

/// Invitation to book consultation
class _ConsultationCard extends StatelessWidget {
  const _ConsultationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.s(18)),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(context.s(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.s(8),
                  vertical: context.s(3),
                ),
                decoration: BoxDecoration(
                  color: AppColors.brass,
                  borderRadius: BorderRadius.circular(context.s(4)),
                ),
                child: Text(
                  'COMPLIMENTARY',
                  style: AppText.caption2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.s(8)),
          Text(
            'Ready to design your home?',
            style: AppText.title.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.s(4)),
          Text(
            'Connect with our senior architects for an initial floor-plan review and tailored cost estimate.',
            style: AppText.caption.copyWith(
              color: AppColors.white.withOpacity(0.85),
            ),
          ),
          SizedBox(height: context.s(14)),
          InkWell(
            onTap: () => context.go('/support'),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.s(18),
                vertical: context.s(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.s(8)),
              ),
              child: Text(
                'Book Consultation',
                style: AppText.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
