import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';

class RakBrandHeader extends StatelessWidget {
  const RakBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final constrained = context.figHeightConstrained;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.s(24),
        context.s(constrained ? 12 : 24),
        context.s(24),
        context.s(26),
      ),
      child: SizedBox(
        height: context.s(56),
        child: Row(
          children: [
            Image.asset(
              'assets/branding/rak_logo.png',
              width: context.s(94),
              height: context.s(56),
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              semanticLabel: 'RAK Interiors',
            ),
            SizedBox(width: context.s(16)),
            Expanded(
              child: FigText(
                'Thoughtfully made.\nBeautifully yours.',
                style: AppText.caption,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
