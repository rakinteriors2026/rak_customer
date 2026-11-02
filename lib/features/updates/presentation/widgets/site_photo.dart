import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';

class SitePhoto extends StatelessWidget {
  const SitePhoto({super.key, required this.access});

  final AssetAccess access;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      sitePhotoAsset(access),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) =>
          const ColoredBox(color: AppColors.sand),
    );
  }
}

/// Local stand-in for a published site photo. The hint decides the room;
/// the id keeps two shots in the same update from looking identical.
String sitePhotoAsset(AssetAccess access) {
  final second = access.assetId.endsWith('2');
  return switch (access.visualHint) {
    'kitchen' => 'assets/photos/courtyard_home.png',
    'living' => 'assets/photos/living_room_design.png',
    'joinery' =>
      second
          ? 'assets/photos/hero_home.png'
          : 'assets/photos/oak_laminate.png',
    _ => 'assets/photos/hero_home.png',
  };
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
            style: (compact ? AppText.caption2 : AppText.caption)
                .fig(context)
                .copyWith(color: AppColors.inkMuted),
          ),
        ),
      ),
    );
  }
}

