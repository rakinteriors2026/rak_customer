import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';

class RakPurchaseBar extends StatelessWidget {
  const RakPurchaseBar({
    super.key,
    this.summary,
    required this.actionLabel,
    this.onAction,
    this.loading = false,
  });

  final String? summary;
  final String actionLabel;
  final VoidCallback? onAction;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final compact = context.figHeightConstrained;
    final pad = compact ? 8.0 : 16.0;
    return Material(
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.s(16),
          context.s(pad),
          context.s(16),
          context.s(pad) + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (summary != null && summary!.isNotEmpty) ...[
              FigText(summary!, style: AppText.label),
              SizedBox(height: context.s(8)),
            ],
            RakButton(
              label: actionLabel,
              loading: loading,
              onPressed: onAction,
            ),
          ],
        ),
      ),
    );
  }
}
