import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';

class RakProgressBar extends StatelessWidget {
  const RakProgressBar({super.key, required this.value, this.height = 6});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0, 1)),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) {
          return LinearProgressIndicator(
            value: animated,
            minHeight: height,
            backgroundColor: AppColors.line,
            color: AppColors.accent,
          );
        },
      ),
    );
  }
}
