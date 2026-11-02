import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rak_customer/core/theme/app_colors.dart';

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({
    super.key,
    required this.imageHint,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String imageHint;
  final double? width;
  final double? height;
  final BoxFit fit;

  static const placeholderAsset = 'assets/icons/product_placeholder.svg';

  static const _assets = {
    'table': 'assets/products/linen_lounge_chair.png',
    'sofa': 'assets/products/oak_accent_chair.png',
    'light': 'assets/products/sage_lounge_chair.png',
    'wardrobe': 'assets/products/studio_armchair.png',
    'rug': 'assets/products/linen_lounge_chair.png',
    'chair': 'assets/products/linen_lounge_chair.png',
  };

  static String assetFor(String imageHint) =>
      _assets[imageHint] ?? placeholderAsset;

  static bool _isRaster(String asset) {
    return asset.endsWith('.png') ||
        asset.endsWith('.jpg') ||
        asset.endsWith('.jpeg') ||
        asset.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded =
            constraints.hasBoundedWidth && constraints.hasBoundedHeight;
        if (!bounded) return _picture();
        return ColoredBox(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(child: _picture(cover: true)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _picture({bool cover = false}) {
    final asset = assetFor(imageHint);
    final imageFit = cover ? BoxFit.cover : fit;
    if (_isRaster(asset)) {
      return Image.asset(
        asset,
        width: cover ? null : width,
        height: cover ? null : height,
        fit: imageFit,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) =>
            _ArtworkFallback(width: width, height: height),
      );
    }

    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (_) => _ArtworkFallback(width: width, height: height),
      errorBuilder: (context, error, stackTrace) =>
          _ArtworkFallback(width: width, height: height),
    );
  }
}

class _ArtworkFallback extends StatelessWidget {
  const _ArtworkFallback({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.sand,
      child: SizedBox(
        width: width,
        height: height,
        child: const Center(
          child: Icon(Icons.chair_outlined, color: AppColors.muted),
        ),
      ),
    );
  }
}
