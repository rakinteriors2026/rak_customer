import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/repositories/cart_count_repository.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
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

class CartPage extends StatelessWidget {
  const CartPage({super.key, this.accountId});

  final String? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartCubit>()..load(accountId: accountId),
      child: _CartLive(
        accountId: accountId,
        child: _CartView(accountId: accountId),
      ),
    );
  }
}

class _CartLive extends StatefulWidget {
  const _CartLive({required this.accountId, required this.child});

  final String? accountId;
  final Widget child;

  @override
  State<_CartLive> createState() => _CartLiveState();
}

class _CartLiveState extends State<_CartLive> {
  StreamSubscription<int>? _cartCount;

  @override
  void initState() {
    super.initState();
    _cartCount = sl<CartCountRepository>()
        .watch(accountId: widget.accountId)
        .skip(1)
        .listen((_) {
          if (!mounted) return;
          context.read<CartCubit>().load(
            accountId: widget.accountId,
            silent: true,
          );
        });
  }

  @override
  void dispose() {
    _cartCount?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
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
            final empty = state is CartEmpty;
            return RakPage(
              title: empty ? 'Your cart is empty' : 'Your cart',
              subtitle: empty
                  ? 'Find a piece you will love.'
                  : '${branch.name} · ${branch.area}',
              onBack: context.canPop() ? () => context.pop() : null,
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
                    TextButton(
                      onPressed: () => context.go('/favourites'),
                      child: const Text('Go to favourites'),
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
    final note = cart.hasUnavailableLine
        ? 'One piece is not available at this branch.'
        : cart.hasRepricedLine
        ? 'A price in this cart has changed.'
        : cart.hasMixedFulfilment
        ? 'Ready-made and made-to-order pieces ship on different dates.'
        : null;
    return ListView(
      padding: context.figPagePadding,
      children: [
        if (note != null) ...[
          FigText(note, style: AppText.caption),
          SizedBox(height: context.s(8)),
        ],
        for (var i = 0; i < cart.lines.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.line),
          _CartLine(line: cart.lines[i], accountId: accountId),
        ],
        const Divider(height: 1, color: AppColors.line),
        _MoneyLine(label: 'Subtotal', amount: subtotal),
        _MoneyLine(label: 'Delivery', amount: delivery),
        SizedBox(height: context.s(8)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(child: FigText('Total', style: AppText.caption)),
            FigText(MoneyFormatter.format(total), style: AppText.display),
          ],
        ),
        SizedBox(height: context.s(4)),
        const FigText(
          'Taxes included. Delivery is confirmed at checkout.',
          style: AppText.caption,
        ),
        SizedBox(height: context.s(20)),
        RakButton(
          label: cart.hasUnavailableLine
              ? 'Choose another branch'
              : 'Continue to checkout',
          onPressed: () => cart.hasUnavailableLine
              ? context.push('/shop/branch')
              : context.push('/checkout'),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.go('/shop'),
            child: const Text('Continue shopping'),
          ),
        ),
      ],
    );
  }
}

class _MoneyLine extends StatelessWidget {
  const _MoneyLine({required this.label, required this.amount});

  final String label;
  final Money amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(10)),
      child: Row(
        children: [
          Expanded(child: FigText(label, style: AppText.caption)),
          FigText(MoneyFormatter.format(amount), style: AppText.label),
        ],
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  const _CartLine({required this.line, this.accountId});

  final CartLine line;
  final String? accountId;

  @override
  Widget build(BuildContext context) {
    final thumb = context.s(72);
    final asset = ProductArtwork.assetFor(line.imageHint);
    final price = MoneyFormatter.format(
      Money(minorUnits: line.unitPriceMinor, currency: line.currency),
    );
    final status = line.unavailable
        ? 'No longer available'
        : line.repriced
        ? 'Price changed'
        : line.fulfilmentNote;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.s(8)),
            child: ColoredBox(
              color: AppColors.sand,
              child: SizedBox(
                width: thumb,
                height: thumb,
                child: Padding(
                  padding: EdgeInsets.all(context.s(8)),
                  child: Image.asset(
                    asset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: context.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText(
                  line.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label,
                ),
                SizedBox(height: context.s(2)),
                FigText(price, style: AppText.label),
                if (status != null) ...[
                  SizedBox(height: context.s(2)),
                  FigText(status, style: AppText.caption),
                ],
                SizedBox(height: context.s(8)),
                Row(
                  children: [
                    _StepButton(
                      icon: CupertinoIcons.minus,
                      onPressed: () => context.read<CartCubit>().setQuantity(
                        lineId: line.id,
                        quantity: line.quantity - 1,
                        accountId: accountId,
                      ),
                    ),
                    SizedBox(
                      width: context.s(28),
                      child: FigText(
                        '${line.quantity}',
                        style: AppText.label,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _StepButton(
                      icon: CupertinoIcons.plus,
                      onPressed: () => context.read<CartCubit>().setQuantity(
                        lineId: line.id,
                        quantity: line.quantity + 1,
                        accountId: accountId,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.read<CartCubit>().setQuantity(
                        lineId: line.id,
                        quantity: 0,
                        accountId: accountId,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Remove'),
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

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tight(Size.square(context.s(28))),
      icon: Icon(icon, size: context.s(14), color: AppColors.ink),
    );
  }
}
