import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';

class RakStatusBanner extends StatelessWidget {
  const RakStatusBanner({super.key, required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.s(AppRadii.banner);
    return Material(
      color: AppColors.soft,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: EdgeInsets.all(context.s(12)),
          child: FigText(text, style: AppText.caption, color: AppColors.accent),
        ),
      ),
    );
  }
}
