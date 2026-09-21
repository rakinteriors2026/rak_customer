import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
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
import 'package:rak_customer/shared/widgets/rak_purchase_bar.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

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
        return RakPage(
          title: product.name,
          subtitle: 'Branch: ${branch.label}',
          onBack: () => context.pop(),
          bottomBar: RakPurchaseBar(
            summary: unavailableHere
                ? 'Unavailable at this branch'
                : product.canAddToCart
                ? '$_priceLabel · 1 item'
                : 'Made for your space',
            actionLabel: unavailableHere
                ? 'Choose another branch'
                : product.canAddToCart
                ? 'Add to cart'
                : 'Request a quote',
            loading: busy,
            onAction: () async {
              if (unavailableHere) {
                context.push('/shop/unavailable');
                return;
              }
              if (canBuy) {
                final notice = await onAddToCart(product);
                if (context.mounted) {
                  context.read<ProductDetailCubit>().showNotice(notice);
                }
              } else {
                context.push('/enquiry?productId=${product.id}');
              }
            },
          ),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              ProductArtwork(
                imageHint: product.imageHint,
                width: double.infinity,
                height: context.s(AppLayout.heroProductHeight),
              ),
              SizedBox(height: context.s(8)),
              RakButton(
                label: 'Visualise · 360°, AI room & AR',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push(
                  '/shop/products/${product.id}/visualise',
                  extra: product.name,
                ),
              ),
              SizedBox(height: context.s(8)),
              Row(
                children: [
                  Expanded(child: FigText(_priceLabel, style: AppText.heading)),
                  SizedBox(
                    width: context.s(100),
                    child: FigText(
                      unavailableHere
                          ? 'Unavailable here'
                          : product.canAddToCart
                          ? 'In stock'
                          : 'Quote only',
                      style: AppText.caption,
                      color: product.canAddToCart && !unavailableHere
                          ? AppColors.success
                          : AppColors.muted,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.s(8)),
              FigText(
                product.description,
                style: AppText.body,
                color: AppColors.muted,
              ),
              SizedBox(height: context.s(8)),
              RakStatusBanner(text: product.specs),
              SizedBox(height: context.s(8)),
              FigText('Delivery postcode', style: AppText.caption),
              SizedBox(height: context.s(8)),
              const TextField(
                decoration: InputDecoration(
                  hintText: '680121   ·   Delivery available',
                ),
              ),
              SizedBox(height: context.s(8)),
              FigText(
                'Estimated delivery: 5–7 working days.\nDelivery charge confirmed at checkout.',
                style: AppText.caption,
              ),
              const SizedBox(height: AppSpacing.md),
              RakButton(
                label: 'View saved products',
                style: RakButtonStyle.secondary,
                onPressed: () => context.push('/favourites'),
              ),
            ],
          ),
        );
      },
    );
  }
}
