import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';

class SitePhoto extends StatelessWidget {
  const SitePhoto({super.key, required this.access, this.compact = false});

  final AssetAccess access;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(
          _iconFor(access.visualHint),
          size: compact ? 28 : 72,
          color: AppColors.primary.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class WithdrawnPhotoPlaceholder extends StatelessWidget {
  const WithdrawnPhotoPlaceholder({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'No longer available',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.inkMuted,
              fontSize: compact ? 11 : 14,
            ),
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String hint) {
  return switch (hint) {
    'kitchen' => Icons.countertops_outlined,
    'living' => Icons.weekend_outlined,
    _ => Icons.door_sliding_outlined,
  };
}
