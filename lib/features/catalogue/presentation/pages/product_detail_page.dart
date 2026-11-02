import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/catalogue/domain/entities/catalogue_product.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/product_detail_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/is_product_available_at_branch.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/product_artwork.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';

typedef ProductAction = Future<String> Function(CatalogueProduct product);

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.onAddToCart,
    required this.onRequestQuote,
  });

  final String productId;
  final ProductAction onAddToCart;
  final ProductAction onRequestQuote;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductDetailCubit>()..load(productId),
      child: _ProductDetailView(
        productId: productId,
        onAddToCart: onAddToCart,
        onRequestQuote: onRequestQuote,
      ),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({
    required this.productId,
    required this.onAddToCart,
    required this.onRequestQuote,
  });

  final String productId;
  final ProductAction onAddToCart;
  final ProductAction onRequestQuote;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listenWhen: (previous, current) {
        if (current is! ProductDetailLoaded || current.notice == null) {
          return false;
        }
        return previous is! ProductDetailLoaded ||
            previous.notice != current.notice;
      },
      listener: (context, state) {
        if (state is ProductDetailLoaded && state.notice != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.notice!)));
        }
      },
      buildWhen: (previous, current) {
        if (previous is ProductDetailLoaded && current is ProductDetailLoaded) {
          return previous.product != current.product ||
              previous.busy != current.busy;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) {
        return switch (state) {
          ProductDetailLoading() => const RakPage(
            title: 'Product',
            subtitle: 'Loading details',
            child: AppLoading(),
          ),
          ProductDetailError(:final message) => RakPage(
            title: 'Product',
            subtitle: 'Something went wrong',
            onBack: () => context.pop(),
            child: AppErrorState(
              message: message,
              onRetry: () => context.read<ProductDetailCubit>().load(productId),
            ),
          ),
          ProductDetailLoaded(:final product, :final busy) =>
            BlocBuilder<ShopBranchCubit, ShopBranch>(
              bloc: sl<ShopBranchCubit>(),
              builder: (context, branch) {
                return _LoadedDetail(
                  product: product,
                  busy: busy,
                  branch: branch,
                  onAddToCart: onAddToCart,
                  onRequestQuote: onRequestQuote,
                );
              },
            ),
        };
      },
    );
  }
}

class _LoadedDetail extends StatelessWidget {
  const _LoadedDetail({
    required this.product,
    required this.busy,
    required this.branch,
    required this.onAddToCart,
    required this.onRequestQuote,
  });

  final CatalogueProduct product;
  final bool busy;
  final ShopBranch branch;
  final ProductAction onAddToCart;
  final ProductAction onRequestQuote;

  String get _priceLabel {
    if (product.priceMinor == null) return 'Price on request';
    return MoneyFormatter.format(
      Money(minorUnits: product.priceMinor!, currency: product.currency),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: ValueKey(branch.id),
      future: sl<IsProductAvailableAtBranch>()(productId: product.id),
      builder: (context, snapshot) {
        final available = snapshot.data?.valueOrNull ?? true;
        final canBuy = product.canAddToCart && available;
        final unavailableHere = product.canAddToCart && !available;
        final lead = switch (product.salesMode) {
          SalesMode.madeToOrder =>
            'About 6–8 weeks. Delivery charge confirmed at checkout.',
          SalesMode.quotationOnly =>
            'Quoted separately. This piece is not added to the cart.',
          SalesMode.fixedPrice =>
            'About 5–7 working days. Delivery charge confirmed at checkout.',
        };
        final status = unavailableHere
            ? 'Unavailable here'
            : switch (product.salesMode) {
                SalesMode.madeToOrder => 'Made to order',
                SalesMode.quotationOnly => 'Quote only',
                SalesMode.fixedPrice => 'In stock',
              };
        final specs = product.specs
            .split('·')
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .map((part) => part[0].toUpperCase() + part.substring(1))
            .toList();
        return RakPage(
          title: product.name,
          subtitle: '${branch.name} · ${branch.area}',
          onBack: () => context.pop(),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              _ProductPhoto(imageHint: product.imageHint),
              SizedBox(height: context.s(20)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: FigText(_priceLabel, style: AppText.display)),
                  SizedBox(width: context.s(12)),
                  FigText(status, style: AppText.caption),
                ],
              ),
              SizedBox(height: context.s(8)),
              FigText(
                product.description,
                style: AppText.body,
                color: AppColors.muted,
              ),
              SizedBox(height: context.s(20)),
              const Divider(height: 1, color: AppColors.line),
              for (final spec in specs) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.s(14)),
                  child: FigText(spec, style: AppText.label),
                ),
                const Divider(height: 1, color: AppColors.line),
              ],
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.s(14)),
                child: FigText(lead, style: AppText.caption),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.viewfinder,
                title: 'View in your room',
                detail: 'Place it, then walk around to see every side',
                onTap: () => context.push(
                  '/shop/products/${product.id}/ar?hint=${product.imageHint}&specs=${Uri.encodeComponent(product.specs)}',
                  extra: product.name,
                ),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.cube,
                title: 'Visualise',
                detail: '360°, AI room and AR',
                onTap: () => context.push(
                  '/shop/products/${product.id}/visualise?hint=${product.imageHint}&specs=${Uri.encodeComponent(product.specs)}',
                  extra: product.name,
                ),
              ),
              const Divider(height: 1, color: AppColors.line),
              _QuietLink(
                icon: CupertinoIcons.heart,
                title: 'Saved pieces',
                detail: 'Pieces you kept',
                onTap: () => context.push('/favourites'),
              ),
              if (canBuy) ...[
                const Divider(height: 1, color: AppColors.line),
                _QuietLink(
                  icon: CupertinoIcons.cart,
                  title: 'Add to cart',
                  detail: 'Keep this piece in your cart',
                  onTap: busy
                      ? () {}
                      : () async {
                          final notice = await onAddToCart(product);
                          if (context.mounted) {
                            context.read<ProductDetailCubit>().showNotice(
                              notice,
                            );
                          }
                        },
                ),
              ],
              SizedBox(height: context.s(20)),
              RakButton(
                label: unavailableHere
                    ? 'Choose another branch'
                    : product.canAddToCart
                    ? 'Get now'
                    : 'Request a quote',
                loading: busy,
                onPressed: busy
                    ? null
                    : () async {
                        if (unavailableHere) {
                          context.push('/shop/unavailable');
                          return;
                        }
                        if (canBuy) {
                          final notice = await onAddToCart(product);
                          if (!context.mounted) return;
                          if (notice == 'Added to cart') {
                            context.push('/checkout');
                            return;
                          }
                          context.read<ProductDetailCubit>().showNotice(
                            notice,
                          );
                        } else {
                          context.push('/enquiry?productId=${product.id}');
                        }
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductPhoto extends StatelessWidget {
  const _ProductPhoto({required this.imageHint});

  final String imageHint;

  @override
  Widget build(BuildContext context) {
    final asset = ProductArtwork.assetFor(imageHint);
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.s(12)),
      child: ColoredBox(
        color: AppColors.sand,
        child: SizedBox(
          height: context.s(280),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(context.s(28)),
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuietLink extends StatelessWidget {
  const _QuietLink({
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
