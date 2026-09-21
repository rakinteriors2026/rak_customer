import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';

class RakPhoto extends StatelessWidget {
  const RakPhoto({
    super.key,
    required this.asset,
    this.height,
    this.radius,
  });

  final String asset;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final r = context.s(radius ?? AppRadii.button);
    return ClipRRect(
      borderRadius: r <= 0 ? BorderRadius.zero : BorderRadius.circular(r),
      child: SizedBox(
        width: double.infinity,
        height: context.s(height ?? AppLayout.heroHomeHeight),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: AppColors.sand,
            child: SizedBox(
              width: double.infinity,
              height: context.s(height ?? AppLayout.heroHomeHeight),
            ),
          ),
        ),
      ),
    );
  }
}
