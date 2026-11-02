import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/core/theme/app_theme.dart';

class RakInfoCard extends StatelessWidget {
  const RakInfoCard({
    super.key,
    required this.title,
    required this.detail,
    this.onTap,
    this.shadow,
  });

  final String title;
  final String detail;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppRadii.card);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ?? AppDecorations.card,
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          splashColor: AppColors.accent.withValues(alpha: 0.10),
          highlightColor: AppColors.accent.withValues(alpha: 0.05),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.s(AppLayout.infoCardMinHeight),
            ),
            child: Padding(
              padding: EdgeInsets.all(context.s(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.title.fig(context)),
                  SizedBox(height: context.s(8)),
                  Text(
                    detail,
                    style: AppText.body
                        .fig(context)
                        .copyWith(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
