import 'package:flutter/cupertino.dart';
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
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/cart/domain/entities/delivery_address.dart';
import 'package:rak_customer/features/cart/domain/entities/shop_order.dart';
import 'package:rak_customer/features/cart/domain/entities/shopping_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/list_shop_orders.dart';
import 'package:rak_customer/features/cart/domain/usecases/place_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/update_shop_order_status.dart';
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
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_purchase_bar.dart';

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

Future<void> _editCheckoutAddress(BuildContext context) async {
  await context.push('/address');
  if (context.mounted) context.read<CheckoutCubit>().load();
}

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
              subtitle: '${branch.name} · ${branch.area}',
              onBack: () => context.pop(),
              bottomBar: ready == null
                  ? null
                  : RakPurchaseBar(
                      actionLabel: blocked
                          ? 'Choose another branch'
                          : ready.address == null
                          ? 'Add delivery address'
                          : 'Pay $totalLabel',
                      onAction: blocked
                          ? () => context.push('/shop/branch')
                          : ready.address == null
                          ? () => _editCheckoutAddress(context)
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
                    if (cart.hasUnavailableLine)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: FigText(
                          'One piece is not available at this branch.',
                          style: AppText.caption,
                        ),
                      ),
                    _CheckoutAddressRow(address: address),
                    const Divider(height: 1, color: AppColors.line),
                    for (var i = 0; i < cart.lines.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, color: AppColors.line),
                      _CheckoutLine(line: cart.lines[i]),
                    ],
                    const Divider(height: 1, color: AppColors.line),
                    _AmountDetailRow(
                      label: 'Subtotal',
                      amount: MoneyFormatter.format(
                        Money(
                          minorUnits: cart.totalMinor,
                          currency: cart.currency,
                        ),
                      ),
                    ),
                    SizedBox(height: context.s(10)),
                    _AmountDetailRow(
                      label: 'Delivery',
                      amount: MoneyFormatter.format(_delivery(cart)),
                    ),
                    SizedBox(height: context.s(12)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: FigText('Total', style: AppText.caption),
                        ),
                        FigText(
                          MoneyFormatter.format(_payable(cart)),
                          style: AppText.display,
                        ),
                      ],
                    ),
                    SizedBox(height: context.s(8)),
                    const FigText(
                      'Taxes included. Choose UPI or card on the next step.',
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
        final methodLabel = _method == _PayMethod.upi ? 'UPI' : 'Card';
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
                _PayChoice(
                  title: 'UPI',
                  detail: 'Approve in your UPI app',
                  selected: _method == _PayMethod.upi,
                  onTap: () => setState(() => _method = _PayMethod.upi),
                ),
                const Divider(height: 1, color: AppColors.line),
                _PayChoice(
                  title: 'Card or net banking',
                  detail: 'Approve with card or net banking',
                  selected: _method == _PayMethod.card,
                  onTap: () => setState(() => _method = _PayMethod.card),
                ),
                const Divider(height: 1, color: AppColors.line),
                for (var i = 0; i < cart.lines.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.s(12)),
                    child: _AmountDetailRow(
                      label: '${cart.lines[i].name} · ${cart.lines[i].quantity}',
                      amount: MoneyFormatter.format(
                        Money(
                          minorUnits:
                              cart.lines[i].unitPriceMinor *
                              cart.lines[i].quantity,
                          currency: cart.lines[i].currency,
                        ),
                      ),
                    ),
                  ),
                ],
                const Divider(height: 1, color: AppColors.line),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.s(12)),
                  child: _AmountDetailRow(
                    label: 'Delivery',
                    amount: MoneyFormatter.format(_delivery(cart)),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: FigText('Total', style: AppText.caption),
                    ),
                    FigText(
                      MoneyFormatter.format(_payable(cart)),
                      style: AppText.display,
                    ),
                  ],
                ),
                SizedBox(height: context.s(8)),
                const FigText(
                  'The order is confirmed only after this payment is verified.',
                  style: AppText.caption,
                ),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/checkout'),
                    child: const Text('Return to checkout'),
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

class _CheckoutAddressRow extends StatelessWidget {
  const _CheckoutAddressRow({required this.address});

  final DeliveryAddress? address;

  @override
  Widget build(BuildContext context) {
    final title = address == null
        ? 'Add a delivery address'
        : address!.fullName;
    final detail = address == null
        ? 'Where this order should arrive'
        : '${address!.line} · ${address!.postcode}';
    return InkWell(
      onTap: () => _editCheckoutAddress(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(16)),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.location,
              size: context.s(18),
              color: AppColors.ink,
            ),
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

class _CheckoutLine extends StatelessWidget {
  const _CheckoutLine({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final amount = MoneyFormatter.format(
      Money(
        minorUnits: line.unitPriceMinor * line.quantity,
        currency: line.currency,
      ),
    );
    final note = line.unavailable
        ? 'No longer available'
        : line.repriced
        ? line.fulfilmentNote == null
              ? 'Price changed'
              : 'Price changed · ${line.fulfilmentNote}'
        : line.fulfilmentNote;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigText(line.name, style: AppText.label),
                SizedBox(height: context.s(2)),
                FigText('Qty ${line.quantity}', style: AppText.caption),
                if (note != null && note.isNotEmpty) ...[
                  SizedBox(height: context.s(2)),
                  FigText(note, style: AppText.caption),
                ],
              ],
            ),
          ),
          SizedBox(width: context.s(12)),
          FigText(amount, style: AppText.label),
        ],
      ),
    );
  }
}

class _OutcomeRow extends StatelessWidget {
  const _OutcomeRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(14)),
        child: Row(
          children: [
            Expanded(child: FigText(title, style: AppText.label)),
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

class _PayChoice extends StatelessWidget {
  const _PayChoice({
    required this.title,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(14)),
        child: Row(
          children: [
            Icon(
              selected
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle,
              size: context.s(18),
              color: AppColors.ink,
            ),
            SizedBox(width: context.s(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(title, style: AppText.label),
                  if (detail.isNotEmpty) ...[
                    SizedBox(height: context.s(2)),
                    FigText(detail, style: AppText.caption),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
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
                  _AddressField(
                    label: 'Full name',
                    controller: _fullName,
                    enabled: !submitting,
                    hint: 'Full name',
                  ),
                  _AddressField(
                    label: 'Mobile number',
                    controller: _mobile,
                    enabled: !submitting,
                    hint: '10-digit mobile',
                    keyboardType: TextInputType.phone,
                  ),
                  _AddressField(
                    label: 'Address',
                    controller: _line,
                    enabled: !submitting,
                    hint: 'House, street, locality',
                  ),
                  _AddressField(
                    label: 'PIN',
                    controller: _postcode,
                    enabled: !submitting,
                    hint: '6-digit PIN',
                    keyboardType: TextInputType.number,
                    helper: 'Kochi, Trivandrum, Calicut, or Bengaluru',
                  ),
                  if (errorMessage != null) ...[
                    SizedBox(height: context.s(8)),
                    Text(
                      errorMessage,
                      softWrap: true,
                      style: AppText.caption
                          .fig(context)
                          .copyWith(color: AppColors.error),
                    ),
                  ],
                  SizedBox(height: context.s(20)),
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

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.enabled,
    this.keyboardType,
    this.helper,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final line = UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.line, width: context.s(1)),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: context.s(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FigText(label, style: AppText.caption),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            style: AppText.label.fig(context),
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(vertical: context.s(8)),
              border: line,
              enabledBorder: line,
              focusedBorder: line.copyWith(
                borderSide: BorderSide(
                  color: AppColors.ink,
                  width: context.s(1.2),
                ),
              ),
            ),
          ),
          if (helper != null) ...[
            SizedBox(height: context.s(4)),
            FigText(helper!, style: AppText.caption),
          ],
        ],
      ),
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

class _PaymentPendingView extends StatefulWidget {
  const _PaymentPendingView();

  @override
  State<_PaymentPendingView> createState() => _PaymentPendingViewState();
}

class _PaymentPendingViewState extends State<_PaymentPendingView> {
  var _held = false;
  var _delayed = false;

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
                    FigText(totalLabel, style: AppText.display),
                    SizedBox(height: context.s(4)),
                    FigText(itemName, style: AppText.caption),
                    SizedBox(height: context.s(12)),
                    const FigText(
                      'If money has been debited, do not pay again.',
                      style: AppText.caption,
                    ),
                    if (_held) ...[
                      SizedBox(height: context.s(8)),
                      const FigText(
                        'Payment pending. Closing this screen does not confirm the order.',
                        style: AppText.caption,
                      ),
                    ],
                    if (_delayed) ...[
                      SizedBox(height: context.s(8)),
                      const FigText(
                        'The bank has not confirmed this payment yet. Check again before paying a second time.',
                        style: AppText.caption,
                      ),
                    ],
                    SizedBox(height: context.s(20)),
                    RakButton(
                      label: _delayed
                          ? 'Confirm delayed payment'
                          : 'Payment successful',
                      loading: checking,
                      onPressed: checking
                          ? null
                          : () => context.read<PlaceOrderCubit>().submit(),
                    ),
                    SizedBox(height: context.s(8)),
                    const Divider(height: 1, color: AppColors.line),
                    _OutcomeRow(
                      title: 'Payment failed',
                      onTap: checking
                          ? null
                          : () => context.go(
                              '/checkout/failed',
                              extra: PaymentFailedArgs(
                                message:
                                    'The demo payment was declined. Your cart is unchanged.',
                                amountLabel: totalLabel,
                              ),
                            ),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _OutcomeRow(
                      title: 'Payment cancelled',
                      onTap: checking ? null : () => context.go('/checkout'),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _OutcomeRow(
                      title: 'Leave payment pending',
                      onTap: checking
                          ? null
                          : () => setState(() {
                              _held = true;
                              _delayed = false;
                            }),
                    ),
                    const Divider(height: 1, color: AppColors.line),
                    _OutcomeRow(
                      title: 'Verification delayed',
                      onTap: checking
                          ? null
                          : () => setState(() {
                              _delayed = true;
                              _held = false;
                            }),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/shop'),
                        child: const Text('Back to shop'),
                      ),
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
      title: 'Confirmed',
      subtitle: 'Your order is accepted.',
      onBack: () => context.go('/shop'),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          FigText(paid, style: AppText.display),
          SizedBox(height: context.s(4)),
          FigText(
            'Order ${order.id} · accepted for ${_firstName(displayName)}',
            style: AppText.caption,
          ),
          SizedBox(height: context.s(8)),
          const Divider(height: 1, color: AppColors.line),
          for (final line in order.lines) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.s(12)),
              child: _AmountDetailRow(
                label: _orderLineSummary(line),
                amount: MoneyFormatter.format(
                  Money(
                    minorUnits: line.unitPriceMinor * line.quantity,
                    currency: line.currency,
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
          SizedBox(height: context.s(8)),
          FigText(
            'Delivery to ${order.address.line} · ${order.address.postcode}',
            style: AppText.caption,
          ),
          SizedBox(height: context.s(20)),
          RakButton(
            label: 'Track order',
            onPressed: () => context.go('/orders/${order.id}'),
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go('/shop'),
              child: const Text('Back to shop'),
            ),
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
    return RakPage(
      title: 'Payment unsuccessful',
      subtitle: 'Your order is not confirmed yet.',
      onBack: () => context.go('/checkout'),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          if (amountLabel != null) ...[
            FigText(amountLabel!, style: AppText.display),
            SizedBox(height: context.s(8)),
          ],
          Text(
            message ??
                'Your payment could not be completed. Check your payment method before retrying.',
            softWrap: true,
            style: AppText.caption.fig(context).copyWith(color: AppColors.ink),
          ),
          SizedBox(height: context.s(20)),
          RakButton(
            label: 'Retry payment',
            onPressed: () => context.go('/checkout/pay'),
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go('/checkout'),
              child: const Text('Return to checkout'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => context.go('/support/new'),
              child: const Text('Contact support'),
            ),
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
          onBack: context.canPop() ? () => context.pop() : null,
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
                for (var i = 0; i < orders.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  InkWell(
                    onTap: () => context.push('/orders/${orders[i].id}'),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: context.s(14)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FigText(
                                  orders[i].statusLabel,
                                  style: AppText.label,
                                ),
                                SizedBox(height: context.s(2)),
                                FigText(orders[i].id, style: AppText.caption),
                              ],
                            ),
                          ),
                          FigText(
                            MoneyFormatter.format(
                              Money(
                                minorUnits: orders[i].totalMinor,
                                currency: orders[i].currency,
                              ),
                            ),
                            style: AppText.label,
                          ),
                          SizedBox(width: context.s(8)),
                          Icon(
                            CupertinoIcons.chevron_right,
                            size: context.s(14),
                            color: AppColors.muted,
                          ),
                        ],
                      ),
                    ),
                  ),
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
        updateShopOrderStatus: sl<UpdateShopOrderStatus>(),
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

  String _fulfilmentTitle(String step) {
    return switch (step) {
      'preparing' => 'Preparing',
      'dispatched' => 'Dispatched',
      'delivered' => 'Delivered',
      _ => 'Confirmed',
    };
  }

  String _stepDetail(String current, String step) {
    final currentIndex = ShopOrder.fulfilmentSteps.indexOf(current);
    final stepIndex = ShopOrder.fulfilmentSteps.indexOf(step);
    if (currentIndex < 0) return 'See cancellation status for this order.';
    if (stepIndex < currentIndex) return 'Complete';
    if (stepIndex == currentIndex) return 'Current';
    return 'Not yet';
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
        final loaded = state is OrderTrackingLoaded ? state.order : null;
        final itemName = loaded == null || loaded.lines.isEmpty
            ? null
            : loaded.lines.first.name;
        return RakPage(
          title: 'Track your order',
          subtitle: loaded == null
              ? 'Status updates as fulfilment progresses.'
              : itemName == null
              ? loaded.id
              : '${loaded.id} · $itemName',
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
                FigText(
                  MoneyFormatter.format(
                    Money(
                      minorUnits: order.totalMinor,
                      currency: order.currency,
                    ),
                  ),
                  style: AppText.display,
                ),
                SizedBox(height: context.s(4)),
                FigText(order.statusLabel, style: AppText.label),
                SizedBox(height: context.s(2)),
                FigText(
                  '${order.address.line} · ${order.address.postcode}',
                  style: AppText.caption,
                ),
                SizedBox(height: context.s(20)),
                _OrderTimeline(
                  stops: [
                    for (final step in ShopOrder.fulfilmentSteps)
                      _TimelineStop(
                        title: _fulfilmentTitle(step),
                        detail: step == 'confirmed'
                            ? _confirmedAt(order.createdAt)
                            : step == 'delivered'
                            ? _deliveryWindow(order.createdAt)
                            : _stepDetail(order.status, step),
                        reached:
                            ShopOrder.fulfilmentSteps.indexOf(order.status) >=
                            ShopOrder.fulfilmentSteps.indexOf(step),
                        current: _stepDetail(order.status, step) == 'Current',
                      ),
                  ],
                ),
                SizedBox(height: context.s(8)),
                const Divider(height: 1, color: AppColors.line),
                for (final line in order.lines)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.s(12)),
                    child: _AmountDetailRow(
                      label: _orderLineSummary(line),
                      amount: MoneyFormatter.format(
                        Money(
                          minorUnits: line.unitPriceMinor * line.quantity,
                          currency: line.currency,
                        ),
                      ),
                    ),
                  ),
                if (order.nextFulfilmentStatus != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () =>
                          context.read<OrderTrackingCubit>().advance(
                            order.nextFulfilmentStatus!,
                          ),
                      child: const Text('Simulate next status'),
                    ),
                  ),
                SizedBox(height: context.s(8)),
                RakButton(
                  label: 'Need help with this order?',
                  onPressed: () =>
                      context.push('/support/new?orderId=${order.id}'),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/orders/${order.id}/help'),
                    child: const Text('Cancellation and returns'),
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

class _TimelineStop {
  const _TimelineStop({
    required this.title,
    required this.detail,
    required this.reached,
    required this.current,
  });

  final String title;
  final String detail;
  final bool reached;
  final bool current;
}

class _OrderTimeline extends StatelessWidget {
  const _OrderTimeline({required this.stops});

  final List<_TimelineStop> stops;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < stops.length; i++)
          _TimelineRow(stop: stops[i], last: i == stops.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.stop, required this.last});

  final _TimelineStop stop;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final dot = context.s(8);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.s(18),
            child: Column(
              children: [
                Container(
                  width: dot,
                  height: dot,
                  margin: EdgeInsets.only(top: context.s(4)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: stop.reached ? AppColors.ink : AppColors.canvas,
                    border: Border.all(
                      color: stop.reached ? AppColors.ink : AppColors.muted,
                      width: 1.5,
                    ),
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: stop.reached && !stop.current
                          ? AppColors.ink
                          : AppColors.line,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: context.s(14)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : context.s(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(
                    stop.title,
                    style: stop.current ? AppText.label : AppText.caption,
                  ),
                  SizedBox(height: context.s(2)),
                  FigText(stop.detail, style: AppText.caption),
                ],
              ),
            ),
          ),
        ],
      ),
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
          const FigText(
            'A request can be sent before dispatch. Refund timing depends on the order status.',
            style: AppText.caption,
          ),
          SizedBox(height: context.s(8)),
          for (final reason in _reasons) ...[
            _PayChoice(
              title: reason,
              detail: '',
              selected: _reason == reason,
              onTap: () => setState(() => _reason = reason),
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
          SizedBox(height: context.s(16)),
          RakButton(
            label: 'Request cancellation',
            onPressed: () =>
                context.go('/orders/${widget.orderId}/cancellation'),
          ),
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: const Text('Keep my order'),
            ),
          ),
        ],
      ),
    );
  }
}

class CancellationRequestedPage extends StatelessWidget {
  const CancellationRequestedPage({
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
        updateShopOrderStatus: sl<UpdateShopOrderStatus>(),
        accountId: accountId,
        orderId: orderId,
      )..load(),
      child: _CancellationView(orderId: orderId),
    );
  }
}

class _CancellationView extends StatelessWidget {
  const _CancellationView({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
      builder: (context, state) {
        return RakPage(
          title: 'Cancellation & refund',
          subtitle: 'Order $orderId',
          onBack: () => context.go('/orders/$orderId'),
          child: switch (state) {
            OrderTrackingLoading() => const AppLoading(),
            OrderTrackingError(:final message) => AppErrorState(
              message: message,
              onRetry: () => context.read<OrderTrackingCubit>().load(),
            ),
            OrderTrackingLoaded(:final order) => ListView(
              padding: context.figPagePadding,
              children: [
                FigText(order.statusLabel, style: AppText.label),
                SizedBox(height: context.s(8)),
                const FigText(
                  'Request cancellation while the order is confirmed or preparing. After dispatch, request a return. A refund in this demo returns to the original payment method.',
                  style: AppText.caption,
                ),
                SizedBox(height: context.s(20)),
                if (order.canRequestCancellation)
                  RakButton(
                    label: 'Submit cancellation request',
                    onPressed: () => context.read<OrderTrackingCubit>().advance(
                      'cancellation_requested',
                    ),
                  ),
                if (order.canRequestReturn)
                  RakButton(
                    label: 'Request a return',
                    onPressed: () => context.read<OrderTrackingCubit>().advance(
                      'return_requested',
                    ),
                  ),
                if (order.status == 'cancellation_requested' ||
                    order.status == 'return_requested')
                  RakButton(
                    label: 'Move to review',
                    onPressed: () => context.read<OrderTrackingCubit>().advance(
                      'under_review',
                    ),
                  ),
                if (order.status == 'under_review') ...[
                  RakButton(
                    label: 'Approve and cancel',
                    onPressed: () => context.read<OrderTrackingCubit>().advance(
                      'cancelled',
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          context.read<OrderTrackingCubit>().advance(
                            'cancellation_rejected',
                          ),
                      child: const Text('Decline request'),
                    ),
                  ),
                ],
                if (order.status == 'cancelled')
                  RakButton(
                    label: 'Start refund',
                    onPressed: () => context.read<OrderTrackingCubit>().advance(
                      'refund_initiated',
                    ),
                  ),
                if (order.status == 'refund_initiated')
                  RakButton(
                    label: 'Complete refund',
                    onPressed: () => context.read<OrderTrackingCubit>().advance(
                      'refund_completed',
                    ),
                  ),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/orders/$orderId'),
                    child: const Text('Track my order'),
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
