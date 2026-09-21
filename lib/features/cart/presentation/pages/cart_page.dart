import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/product_artwork.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_purchase_bar.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, this.accountId});

  final String? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartCubit>()..load(accountId: accountId),
      child: _CartView(accountId: accountId),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView({this.accountId});
  final String? accountId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShopBranch>(
      stream: sl<ShopBranchRepository>().watchSelected(),
      builder: (context, snapshot) {
        final branch = snapshot.data ?? ShopBranch.kochi;
        return BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final loaded = state is CartLoaded ? state.cart : null;
            final blocked = loaded?.hasUnavailableLine ?? false;
            final empty = state is CartEmpty;
            return RakPage(
              title: empty ? 'Your cart is empty' : 'Your cart',
              subtitle: empty
                  ? 'Find a piece you will love.'
                  : 'Branch: ${branch.label}',
              onBack: () => context.pop(),
              bottomBar: loaded == null
                  ? null
                  : RakPurchaseBar(
                      summary: blocked
                          ? 'Unavailable at this branch'
                          : 'Total ${MoneyFormatter.format(_payable(loaded))} · incl. delivery',
                      actionLabel: blocked
                          ? 'Choose another branch'
                          : 'Continue to checkout',
                      onAction: () => blocked
                          ? context.push('/shop/branch')
                          : context.push('/checkout'),
                    ),
              child: switch (state) {
                CartLoading() => const AppLoading(),
                CartEmpty() => ListView(
                  padding: context.figPagePadding,
                  children: [
                    FigText('Nothing in your cart yet', style: AppText.heading),
                    SizedBox(height: context.s(12)),
                    FigText(
                      'Explore furniture and home accents, or revisit your saved products.',
                      style: AppText.body,
                      color: AppColors.muted,
                    ),
                    SizedBox(height: context.s(12)),
                    RakButton(
                      label: 'Back to shop',
                      onPressed: () => context.go('/shop'),
                    ),
                    SizedBox(height: context.s(12)),
                    RakButton(
                      label: 'Go to favourites',
                      style: RakButtonStyle.secondary,
                      onPressed: () => context.go('/favourites'),
                    ),
                  ],
                ),
                CartError(:final message) => AppErrorState(
                  message: message,
                  onRetry: () =>
                      context.read<CartCubit>().load(accountId: accountId),
                ),
                CartLoaded(:final cart) => _CartBody(
                  cart: cart,
                  accountId: accountId,
                ),
              },
            );
          },
        );
      },
    );
  }
}

Money _payable(ShoppingCart cart) {
  return Money(
    minorUnits: cart.totalMinor + AppLayout.deliveryMinor,
    currency: cart.currency,
  );
}

class _CartBody extends StatelessWidget {
  const _CartBody({required this.cart, this.accountId});
  final ShoppingCart cart;
  final String? accountId;

  @override
  Widget build(BuildContext context) {
    final subtotal = Money(
      minorUnits: cart.totalMinor,
      currency: cart.currency,
    );
    final delivery = Money(
      minorUnits: AppLayout.deliveryMinor,
      currency: cart.currency,
    );
    final total = _payable(cart);
    return ListView(
      padding: context.figPagePadding,
      children: [
        if (cart.hasUnavailableLine) ...[
          const RakStatusBanner(
            text:
                'This item is unavailable at your selected branch. Choose another branch before checkout.',
          ),
          SizedBox(height: context.s(12)),
        ],
        ...cart.lines.map(
          (line) => _CartItemCard(line: line, accountId: accountId),
        ),
        SizedBox(height: context.s(12)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(context.s(16)),
          decoration: BoxDecoration(
            color: AppColors.soft,
            borderRadius: BorderRadius.circular(context.s(AppRadii.card)),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AmountRow(label: 'Subtotal', amount: subtotal),
              SizedBox(height: context.s(8)),
              _AmountRow(label: 'Delivery', amount: delivery),
              SizedBox(height: context.s(8)),
              Container(height: 1, color: AppColors.line),
              SizedBox(height: context.s(8)),
              _AmountRow(label: 'Total', amount: total, emphasis: true),
            ],
          ),
        ),
        SizedBox(height: context.s(12)),
        FigText(
          'Taxes included. Availability and delivery charges are confirmed at checkout.',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(12)),
        RakButton(
          label: 'Continue shopping',
          style: RakButtonStyle.secondary,
          onPressed: () => context.go('/shop'),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.amount,
    this.emphasis = false,
  });
  final String label;
  final Money amount;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FigText(label, style: emphasis ? AppText.title : AppText.body),
        ),
        FigText(
          MoneyFormatter.format(amount),
          style: emphasis ? AppText.title : AppText.body,
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.line, this.accountId});
  final CartLine line;
  final String? accountId;

  @override
  Widget build(BuildContext context) {
    final thumb = context.s(AppLayout.cartThumb);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.s(12)),
      padding: EdgeInsets.all(context.s(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.s(AppRadii.card)),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: thumb,
                height: thumb,
                child: ProductArtwork(
                  imageHint: line.imageHint,
                  width: thumb,
                  height: thumb,
                ),
              ),
              SizedBox(width: context.s(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FigText(line.name, style: AppText.title),
                    SizedBox(height: context.s(4)),
                    FigText('Natural oak / Sand', style: AppText.caption),
                    SizedBox(height: context.s(4)),
                    FigText(
                      '${MoneyFormatter.format(Money(minorUnits: line.unitPriceMinor, currency: line.currency))} each',
                      style: AppText.label,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.s(8)),
          Row(
            children: [
              RakButton(
                label: '−',
                style: RakButtonStyle.secondary,
                width: AppLayout.quantityButtonWidth,
                height: AppLayout.quantityButtonHeight,
                onPressed: () => context.read<CartCubit>().setQuantity(
                  lineId: line.id,
                  quantity: line.quantity - 1,
                  accountId: accountId,
                ),
              ),
              SizedBox(
                width: context.s(44),
                child: FigText(
                  '${line.quantity}',
                  style: AppText.label,
                  textAlign: TextAlign.center,
                ),
              ),
              RakButton(
                label: '+',
                style: RakButtonStyle.secondary,
                width: AppLayout.quantityButtonWidth,
                height: AppLayout.quantityButtonHeight,
                onPressed: () => context.read<CartCubit>().setQuantity(
                  lineId: line.id,
                  quantity: line.quantity + 1,
                  accountId: accountId,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.s(AppLayout.tapTarget),
            child: GestureDetector(
              onTap: () => context.read<CartCubit>().setQuantity(
                lineId: line.id,
                quantity: 0,
                accountId: accountId,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FigText('Remove item', style: AppText.caption),
              ),
            ),
          ),
          if (line.repriced)
            FigText(
              'Price changed',
              style: AppText.caption,
              color: AppColors.warning,
            ),
          if (line.unavailable)
            FigText(
              'No longer available',
              style: AppText.caption,
              color: AppColors.error,
            ),
        ],
      ),
    );
  }
}
