import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/money.dart';
import 'package:rak_customer/core/domain/entities/shop_branch.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/list_shop_orders.dart';
import 'package:rak_customer/features/cart/domain/usecases/place_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/save_delivery_address.dart';
import 'package:rak_customer/features/cart/presentation/cubit/address_form_cubit.dart';
import 'package:rak_customer/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:rak_customer/features/cart/presentation/cubit/order_tracking_cubit.dart';
import 'package:rak_customer/features/cart/presentation/cubit/orders_list_cubit.dart';
import 'package:rak_customer/features/cart/presentation/cubit/place_order_cubit.dart';
import 'package:rak_customer/shared/formatters/money_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';
import 'package:rak_customer/shared/widgets/app_loading.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_purchase_bar.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

Money _payable(ShoppingCart cart) {
  return Money(
    minorUnits: cart.totalMinor + AppLayout.deliveryMinor,
    currency: cart.currency,
  );
}

Money _delivery(ShoppingCart cart) {
  return Money(minorUnits: AppLayout.deliveryMinor, currency: cart.currency);
}

String _firstName(String displayName) {
  final parts = displayName.trim().split(RegExp(r'\s+'));
  return parts.isEmpty ? displayName : parts.first;
}

String _addressDetail(DeliveryAddress address) {
  return '${address.line}\n${address.postcode} · ${address.mobile}';
}

String _lineSummary(CartLine line) => '${line.name} · Qty ${line.quantity}';

String _orderLineSummary(ShopOrderLine line) =>
    '${line.name} × ${line.quantity}';

CheckoutCubit _checkoutCubit(String accountId) {
  return CheckoutCubit(
    getCart: sl<GetCart>(),
    getDeliveryAddress: sl<GetDeliveryAddress>(),
    shopBranchRepository: sl<ShopBranchRepository>(),
    accountId: accountId,
  )..load();
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _checkoutCubit(accountId),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShopBranch>(
      stream: sl<ShopBranchRepository>().watchSelected(),
      builder: (context, snapshot) {
        final branch = snapshot.data ?? ShopBranch.kochi;
        return BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final ready = state is CheckoutReady ? state : null;
            final blocked = ready?.cart.hasUnavailableLine ?? false;
            final total = ready == null ? null : _payable(ready.cart);
            final totalLabel = total == null
                ? ''
                : MoneyFormatter.format(total);
            return RakPage(
              title: 'Checkout',
              subtitle: 'Branch: ${branch.label}',
              onBack: () => context.pop(),
              bottomBar: ready == null
                  ? null
                  : RakPurchaseBar(
                      summary: blocked
                          ? 'Unavailable at this branch'
                          : ready.address == null
                          ? 'Add a delivery address to continue'
                          : 'Pay securely · $totalLabel',
                      actionLabel: blocked
                          ? 'Choose another branch'
                          : ready.address == null
                          ? 'Add delivery address'
                          : 'Pay $totalLabel',
                      onAction: blocked
                          ? () => context.push('/shop/branch')
                          : ready.address == null
                          ? () async {
                              await context.push('/address');
                              if (context.mounted) {
                                context.read<CheckoutCubit>().load();
                              }
                            }
                          : () => context.push('/checkout/pay'),
                    ),
              child: switch (state) {
                CheckoutLoading() => const AppLoading(),
                CheckoutEmpty() => AppEmptyState(
                  title: 'Your cart is empty',
                  message: 'Add a piece from the shop before placing an order.',
                  actionLabel: 'Explore the shop',
                  onAction: () => context.go('/shop'),
                  icon: Icons.shopping_bag_outlined,
                ),
                CheckoutError(:final message) => AppErrorState(
                  message: message,
                  onRetry: () => context.read<CheckoutCubit>().load(),
                ),
                CheckoutReady(:final cart, :final address) => ListView(
                  padding: context.figPagePadding,
                  children: [
                    if (cart.hasUnavailableLine) ...[
                      const RakStatusBanner(
                        text:
                            'This item is unavailable at your selected branch. Choose another branch before checkout.',
                      ),
                      SizedBox(height: context.s(12)),
                    ],
                    RakInfoCard(
                      title: address == null
                          ? 'No delivery address yet'
                          : 'Deliver to ${address.fullName}',
                      detail: address == null
                          ? 'Add where this order should arrive before placing it.'
                          : _addressDetail(address),
                    ),
                    SizedBox(height: context.s(12)),
                    RakButton(
                      label: address == null
                          ? 'Add delivery address'
                          : 'Change delivery address',
                      style: RakButtonStyle.secondary,
                      onPressed: () async {
                        await context.push('/address');
                        if (context.mounted) {
                          context.read<CheckoutCubit>().load();
                        }
                      },
                    ),
                    SizedBox(height: context.s(12)),
                    const RakInfoCard(
                      title: 'Estimated delivery',
                      detail: '5–7 working days after confirmation',
                    ),
                    SizedBox(height: context.s(12)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.s(16)),
                      decoration: BoxDecoration(
                        color: AppColors.soft,
                        borderRadius: BorderRadius.circular(
                          context.s(AppRadii.card),
                        ),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final line in cart.lines) ...[
                            FigText(_lineSummary(line), style: AppText.label),
                            SizedBox(height: context.s(8)),
                          ],
                          FigText(
                            'Item ${MoneyFormatter.format(Money(minorUnits: cart.totalMinor, currency: cart.currency))} + Delivery ${MoneyFormatter.format(_delivery(cart))}',
                            style: AppText.body,
                          ),
                          SizedBox(height: context.s(8)),
                          Container(height: 1, color: AppColors.line),
                          SizedBox(height: context.s(8)),
                          FigText(
                            'Total  ${MoneyFormatter.format(_payable(cart))}',
                            style: AppText.heading,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.s(12)),
                    FigText(
                      'Continue to the payment provider to choose UPI, card or another available payment method.',
                      style: AppText.caption,
                    ),
                  ],
                ),
              },
            );
          },
        );
      },
    );
  }
}

enum _PayMethod { upi, card }

class PaymentProviderPage extends StatelessWidget {
  const PaymentProviderPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _checkoutCubit(accountId),
      child: const _PaymentProviderView(),
    );
  }
}

class _PaymentProviderView extends StatefulWidget {
  const _PaymentProviderView();

  @override
  State<_PaymentProviderView> createState() => _PaymentProviderViewState();
}

class _PaymentProviderViewState extends State<_PaymentProviderView> {
  _PayMethod _method = _PayMethod.upi;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final ready = state is CheckoutReady ? state : null;
        final totalLabel = ready == null
            ? ''
            : MoneyFormatter.format(_payable(ready.cart));
        final methodLabel = _method == _PayMethod.upi ? 'UPI' : 'card';
        return RakPage(
          title: 'Secure payment',
          subtitle: ready == null ? 'Order total' : 'Order total · $totalLabel',
          onBack: () => context.pop(),
          bottomBar: ready == null
              ? null
              : RakPurchaseBar(
                  actionLabel: 'Continue with $methodLabel · $totalLabel',
                  onAction: () => context.push('/checkout/pending'),
                ),
          child: switch (state) {
            CheckoutLoading() => const AppLoading(),
            CheckoutEmpty() => AppEmptyState(
              title: 'Your cart is empty',
              message: 'Return to the shop before paying.',
              actionLabel: 'Back to shop',
              onAction: () => context.go('/shop'),
              icon: Icons.shopping_bag_outlined,
            ),
            CheckoutError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<CheckoutCubit>().load(),
            ),
            CheckoutReady(:final cart) => ListView(
              padding: context.figPagePadding,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: AppColors.soft,
                    borderRadius: BorderRadius.circular(context.s(8)),
                    child: Padding(
                      padding: EdgeInsets.all(context.s(8)),
                      child: FigText(
                        'Payment not yet completed',
                        style: AppText.label,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.s(16)),
                FigText('Choose a payment method', style: AppText.screenTitle),
                SizedBox(height: context.s(16)),
                _PaymentMethodCard(
                  label: _method == _PayMethod.upi
                      ? 'UPI'
                      : 'Card or net banking',
                ),
                SizedBox(height: context.s(16)),
                FigText(
                  _method == _PayMethod.upi
                      ? 'Continue to your UPI app to approve the payment.'
                      : 'Continue with card or net banking to approve the payment.',
                  style: AppText.bodyLarge,
                ),
                SizedBox(height: context.s(16)),
                RakButton(
                  label: _method == _PayMethod.upi
                      ? 'Card or net banking'
                      : 'UPI',
                  style: RakButtonStyle.secondary,
                  onPressed: () => setState(() {
                    _method = _method == _PayMethod.upi
                        ? _PayMethod.card
                        : _PayMethod.upi;
                  }),
                ),
                SizedBox(height: context.s(16)),
                Container(height: 1, color: AppColors.line),
                SizedBox(height: context.s(16)),
                for (final line in cart.lines) ...[
                  _AmountDetailRow(
                    label: '${line.name} × ${line.quantity}',
                    amount: MoneyFormatter.format(
                      Money(
                        minorUnits: line.unitPriceMinor * line.quantity,
                        currency: line.currency,
                      ),
                    ),
                  ),
                  SizedBox(height: context.s(16)),
                ],
                _AmountDetailRow(
                  label: 'Delivery',
                  amount: MoneyFormatter.format(_delivery(cart)),
                ),
                SizedBox(height: context.s(16)),
                _AmountDetailRow(
                  label: 'Total payable',
                  amount: MoneyFormatter.format(_payable(cart)),
                ),
                SizedBox(height: context.s(16)),
                FigText(
                  'Once you return, we will check your payment status. Your order is confirmed only after payment is verified.',
                  style: AppText.body,
                  color: AppColors.muted,
                ),
                SizedBox(height: context.s(16)),
                RakButton(
                  label: 'Cancel and return to checkout',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.go('/checkout'),
                ),
              ],
            ),
          },
        );
      },
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.s(16)),
      decoration: BoxDecoration(
        color: AppColors.soft,
        borderRadius: BorderRadius.circular(context.s(AppRadii.button)),
      ),
      child: FigText('●  $label', style: AppText.title),
    );
  }
}

class _AmountDetailRow extends StatelessWidget {
  const _AmountDetailRow({required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FigText(label, style: AppText.body, color: AppColors.muted),
        ),
        FigText(amount, style: AppText.label, textAlign: TextAlign.right),
      ],
    );
  }
}

class AddressPage extends StatelessWidget {
  const AddressPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressFormCubit(
        getDeliveryAddress: sl<GetDeliveryAddress>(),
        saveDeliveryAddress: sl<SaveDeliveryAddress>(),
        accountId: accountId,
      )..load(),
      child: const _AddressView(),
    );
  }
}

class _AddressView extends StatefulWidget {
  const _AddressView();

  @override
  State<_AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<_AddressView> {
  final _fullName = TextEditingController();
  final _mobile = TextEditingController();
  final _line = TextEditingController();
  final _postcode = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _fullName.dispose();
    _mobile.dispose();
    _line.dispose();
    _postcode.dispose();
    super.dispose();
  }

  void _seed(AddressFormReady state) {
    if (_seeded || state.address == null) return;
    _seeded = true;
    _fullName.text = state.address!.fullName;
    _mobile.text = state.address!.mobile;
    _line.text = state.address!.line;
    _postcode.text = state.address!.postcode;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressFormCubit, AddressFormState>(
      listener: (context, state) {
        if (state is AddressFormReady) {
          _seed(state);
        }
        if (state is AddressFormSaved) {
          context.pop();
        }
      },
      builder: (context, state) {
        return RakPage(
          title: 'Delivery address',
          subtitle: 'Where should we send your order?',
          onBack: () => context.pop(),
          child: switch (state) {
            AddressFormLoading() => const AppLoading(),
            AddressFormError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<AddressFormCubit>().load(),
            ),
            AddressFormSaved() => const AppLoading(),
            AddressFormReady(:final submitting, :final errorMessage) =>
              ListView(
                padding: context.figPagePadding,
                children: [
                  FigText('Full name', style: AppText.caption),
                  SizedBox(height: context.s(12)),
                  TextField(
                    controller: _fullName,
                    enabled: !submitting,
                    decoration: const InputDecoration(hintText: 'Full name'),
                  ),
                  SizedBox(height: context.s(12)),
                  FigText('Mobile number', style: AppText.caption),
                  SizedBox(height: context.s(12)),
                  TextField(
                    controller: _mobile,
                    enabled: !submitting,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Mobile number',
                    ),
                  ),
                  SizedBox(height: context.s(12)),
                  FigText('Address', style: AppText.caption),
                  SizedBox(height: context.s(12)),
                  TextField(
                    controller: _line,
                    enabled: !submitting,
                    decoration: const InputDecoration(
                      hintText: 'House / flat, street, locality',
                    ),
                  ),
                  SizedBox(height: context.s(12)),
                  FigText('Postcode', style: AppText.caption),
                  SizedBox(height: context.s(12)),
                  TextField(
                    controller: _postcode,
                    enabled: !submitting,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '6-digit PIN'),
                  ),
                  if (errorMessage != null) ...[
                    SizedBox(height: context.s(12)),
                    FigText(
                      errorMessage,
                      style: AppText.body,
                      color: AppColors.error,
                    ),
                  ],
                  SizedBox(height: context.s(12)),
                  RakButton(
                    label: submitting ? 'Saving…' : 'Save & return to checkout',
                    loading: submitting,
                    onPressed: submitting
                        ? null
                        : () => context.read<AddressFormCubit>().save(
                            fullName: _fullName.text,
                            mobile: _mobile.text,
                            line: _line.text,
                            postcode: _postcode.text,
                          ),
                  ),
                ],
              ),
          },
        );
      },
    );
  }
}

class PaymentPendingPage extends StatelessWidget {
  const PaymentPendingPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _checkoutCubit(accountId)),
        BlocProvider(
          create: (_) => PlaceOrderCubit(
            placeOrder: sl<PlaceOrder>(),
            accountId: accountId,
          ),
        ),
      ],
      child: const _PaymentPendingView(),
    );
  }
}

class _PaymentPendingView extends StatelessWidget {
  const _PaymentPendingView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaceOrderCubit, PlaceOrderState>(
      listener: (context, state) {
        if (state is PlaceOrderSuccess) {
          context.go('/checkout/confirmed', extra: state.order);
        } else if (state is PlaceOrderFailure) {
          final checkout = context.read<CheckoutCubit>().state;
          final amount = checkout is CheckoutReady
              ? MoneyFormatter.format(_payable(checkout.cart))
              : null;
          context.go(
            '/checkout/failed',
            extra: PaymentFailedArgs(
              message: state.message,
              amountLabel: amount,
            ),
          );
        }
      },
      builder: (context, orderState) {
        final checking = orderState is PlaceOrderInProgress;
        return BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            final ready = state is CheckoutReady ? state : null;
            final totalLabel = ready == null
                ? ''
                : MoneyFormatter.format(_payable(ready.cart));
            final itemName = ready == null || ready.cart.lines.isEmpty
                ? 'your order'
                : ready.cart.lines.first.name;
            return RakPage(
              title: 'Checking your payment',
              subtitle: 'Please wait for confirmation.',
              onBack: () => context.go('/checkout'),
              child: switch (state) {
                CheckoutLoading() => const AppLoading(),
                CheckoutEmpty() => AppEmptyState(
                  title: 'Nothing to confirm',
                  message: 'Return to checkout and try the payment again.',
                  actionLabel: 'Return to checkout',
                  onAction: () => context.go('/checkout'),
                ),
                CheckoutError(:final message) => AppErrorState(
                  message: message,
                  onRetry: () => context.read<CheckoutCubit>().load(),
                ),
                CheckoutReady() => ListView(
                  padding: context.figPagePadding,
                  children: [
                    RakStatusBanner(text: 'Order pending · Payment pending'),
                    SizedBox(height: context.s(12)),
                    FigText(
                      'We’re confirming your payment',
                      style: AppText.heading,
                    ),
                    SizedBox(height: context.s(12)),
                    FigText(
                      'If money has been debited, please do not pay again. You can check the status here.',
                      style: AppText.body,
                      color: AppColors.muted,
                    ),
                    SizedBox(height: context.s(12)),
                    RakInfoCard(
                      title: 'Payment amount',
                      detail: '$totalLabel · $itemName',
                    ),
                    SizedBox(height: context.s(12)),
                    RakButton(
                      label: 'Check payment status',
                      loading: checking,
                      onPressed: checking
                          ? null
                          : () => context.read<PlaceOrderCubit>().submit(),
                    ),
                    SizedBox(height: context.s(12)),
                    RakButton(
                      label: 'Back to shop',
                      style: RakButtonStyle.secondary,
                      onPressed: () => context.go('/shop'),
                    ),
                  ],
                ),
              },
            );
          },
        );
      },
    );
  }
}

class PaymentFailedArgs {
  const PaymentFailedArgs({this.message, this.amountLabel});

  final String? message;
  final String? amountLabel;
}

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({
    super.key,
    required this.order,
    required this.displayName,
  });

  final ShopOrder order;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final paid = MoneyFormatter.format(
      Money(minorUnits: order.totalMinor, currency: order.currency),
    );
    return RakPage(
      title: 'A lovely choice.',
      subtitle: 'Your order is confirmed.',
      onBack: () => context.go('/shop'),
      child: ListView(
        padding: context.figPagePadding,
        children: [
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
                FigText('✓', style: AppText.display, color: AppColors.accent),
                SizedBox(height: context.s(8)),
                FigText(
                  'Thank you, ${_firstName(displayName)}',
                  style: AppText.heading,
                ),
                SizedBox(height: context.s(8)),
                FigText('Order ${order.id}', style: AppText.label),
                SizedBox(height: context.s(8)),
                FigText(
                  'We’ll notify you when your order is dispatched.',
                  style: AppText.body,
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
          SizedBox(height: context.s(12)),
          for (final line in order.lines) ...[
            RakInfoCard(
              title: _orderLineSummary(line),
              detail: MoneyFormatter.format(
                Money(minorUnits: line.unitPriceMinor, currency: line.currency),
              ),
            ),
            SizedBox(height: context.s(12)),
          ],
          RakInfoCard(
            title: 'Paid · $paid',
            detail:
                'Delivery to ${order.address.line} · ${order.address.postcode}',
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Track my order',
            onPressed: () => context.go('/orders/${order.id}'),
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Back to shop',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('/shop'),
          ),
        ],
      ),
    );
  }
}

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key, this.message, this.amountLabel});

  final String? message;
  final String? amountLabel;

  @override
  Widget build(BuildContext context) {
    final failedLabel = amountLabel == null
        ? 'Payment failed'
        : 'Payment failed · $amountLabel';
    return RakPage(
      title: 'Payment unsuccessful',
      subtitle: 'Your order is not confirmed yet.',
      onBack: () => context.go('/checkout'),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          RakStatusBanner(text: failedLabel),
          SizedBox(height: context.s(12)),
          FigText('Let’s try that again', style: AppText.heading),
          SizedBox(height: context.s(12)),
          FigText(
            message ??
                'Your payment could not be completed. Check your payment method before retrying.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Return to checkout',
            onPressed: () => context.go('/checkout'),
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Contact support',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('/support/new'),
          ),
        ],
      ),
    );
  }
}

class MissingOrderPage extends StatelessWidget {
  const MissingOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Order not found',
      subtitle: 'There is no confirmed order to show.',
      onBack: () => context.go('/cart'),
      child: AppEmptyState(
        title: 'No confirmation yet',
        message: 'An order is confirmed only after checkout succeeds.',
        actionLabel: 'Back to cart',
        onAction: () => context.go('/cart'),
        icon: Icons.receipt_long_outlined,
      ),
    );
  }
}

class OrdersListPage extends StatelessWidget {
  const OrdersListPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersListCubit(
        listShopOrders: sl<ListShopOrders>(),
        accountId: accountId,
      )..load(),
      child: const _OrdersListView(),
    );
  }
}

class _OrdersListView extends StatelessWidget {
  const _OrdersListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersListCubit, OrdersListState>(
      builder: (context, state) {
        return RakPage(
          title: 'My orders',
          subtitle: 'Purchases, deliveries and returns.',
          onBack: () => context.pop(),
          child: switch (state) {
            OrdersListLoading() => const AppLoading(),
            OrdersListEmpty() => AppEmptyState(
              title: 'No orders yet',
              message:
                  'Confirmed orders will appear here after checkout succeeds.',
              actionLabel: 'Explore the shop',
              onAction: () => context.go('/shop'),
              icon: Icons.receipt_long_outlined,
            ),
            OrdersListError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<OrdersListCubit>().load(),
            ),
            OrdersListLoaded(:final orders) => ListView(
              padding: context.figPagePadding,
              children: [
                for (final order in orders) ...[
                  RakInfoCard(
                    title: order.isConfirmed
                        ? 'Order ${order.id}'
                        : order.status,
                    detail: MoneyFormatter.format(
                      Money(
                        minorUnits: order.totalMinor,
                        currency: order.currency,
                      ),
                    ),
                    onTap: () => context.push('/orders/${order.id}'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          },
        );
      },
    );
  }
}

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({
    super.key,
    required this.accountId,
    required this.orderId,
  });

  final String accountId;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderTrackingCubit(
        getShopOrder: sl<GetShopOrder>(),
        accountId: accountId,
        orderId: orderId,
      )..load(),
      child: const _OrderTrackingView(),
    );
  }
}

class _OrderTrackingView extends StatelessWidget {
  const _OrderTrackingView();

  String _confirmedAt(DateTime createdAt) {
    return DateFormat('dd MMM yyyy · h:mm a').format(createdAt.toLocal());
  }

  String _deliveryWindow(DateTime createdAt) {
    final start = createdAt.toLocal().add(const Duration(days: 7));
    final end = createdAt.toLocal().add(const Duration(days: 9));
    if (start.month == end.month && start.year == end.year) {
      return 'Estimated ${DateFormat('d').format(start)}–${DateFormat('d MMMM yyyy').format(end)}';
    }
    return 'Estimated ${DateFormat('d MMMM').format(start)}–${DateFormat('d MMMM yyyy').format(end)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
      builder: (context, state) {
        final order = state is OrderTrackingLoaded ? state.order : null;
        final itemName = order == null || order.lines.isEmpty
            ? null
            : order.lines.first.name;
        return RakPage(
          title: 'Track your order',
          subtitle: order == null
              ? 'Status updates as fulfilment progresses.'
              : itemName == null
              ? order.id
              : '${order.id} · $itemName',
          onBack: () =>
              context.canPop() ? context.pop() : context.go('/account'),
          child: switch (state) {
            OrderTrackingLoading() => const AppLoading(),
            OrderTrackingError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<OrderTrackingCubit>().load(),
            ),
            OrderTrackingLoaded(:final order) => ListView(
              padding: context.figPagePadding,
              children: [
                RakStatusBanner(
                  text: order.isConfirmed
                      ? 'Processing · Payment received'
                      : 'Processing · ${order.status}',
                ),
                SizedBox(height: context.s(12)),
                RakInfoCard(
                  title: 'Order confirmed',
                  detail: _confirmedAt(order.createdAt),
                ),
                SizedBox(height: context.s(12)),
                const RakInfoCard(
                  title: 'Preparing your order',
                  detail: 'Our team is getting your piece ready',
                ),
                SizedBox(height: context.s(12)),
                const RakInfoCard(
                  title: 'Dispatch',
                  detail: 'Tracking will appear after dispatch',
                ),
                SizedBox(height: context.s(12)),
                RakInfoCard(
                  title: 'Delivery',
                  detail: _deliveryWindow(order.createdAt),
                ),
                SizedBox(height: context.s(12)),
                RakButton(
                  label: 'Need help with this order?',
                  onPressed: () =>
                      context.push('/support/new?orderId=${order.id}'),
                ),
                SizedBox(height: context.s(12)),
                RakButton(
                  label: 'Cancellation & returns',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.push('/orders/${order.id}/help'),
                ),
              ],
            ),
          },
        );
      },
    );
  }
}

class OrderHelpPage extends StatefulWidget {
  const OrderHelpPage({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderHelpPage> createState() => _OrderHelpPageState();
}

class _OrderHelpPageState extends State<OrderHelpPage> {
  static const _reasons = [
    'Ordered by mistake',
    'Changed my mind',
    'Found a better price',
    'Delivery date too late',
  ];

  String _reason = _reasons.first;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Cancellation & returns',
      subtitle: 'Order ${widget.orderId}',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakStatusBanner(
            text: 'Cancellation request available before dispatch',
          ),
          SizedBox(height: context.s(12)),
          FigText('Reason', style: AppText.caption),
          SizedBox(height: context.s(12)),
          DropdownButtonFormField<String>(
            initialValue: _reason,
            decoration: const InputDecoration(),
            items: [
              for (final reason in _reasons)
                DropdownMenuItem(value: reason, child: Text(reason)),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _reason = value);
            },
          ),
          SizedBox(height: context.s(12)),
          FigText(
            'Submit a request for the RAK team to review. Refund eligibility and timing depend on the order status and applicable policy.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Request cancellation',
            onPressed: () =>
                context.go('/orders/${widget.orderId}/cancellation'),
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Keep my order',
            style: RakButtonStyle.secondary,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class CancellationRequestedPage extends StatelessWidget {
  const CancellationRequestedPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Request received',
      subtitle: 'We’ll review your cancellation.',
      onBack: () => context.go('/orders/$orderId'),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          RakStatusBanner(text: 'Cancellation requested · $orderId'),
          SizedBox(height: context.s(12)),
          FigText('Your order is not cancelled yet', style: AppText.heading),
          SizedBox(height: context.s(12)),
          FigText(
            'We’ll update the request after review. Any approved refund will return through the original payment method.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          SizedBox(height: context.s(12)),
          RakButton(
            label: 'Track my order',
            onPressed: () => context.go('/orders/$orderId'),
          ),
        ],
      ),
    );
  }
}
