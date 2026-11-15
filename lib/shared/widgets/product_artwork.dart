import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rak_customer/core/theme/app_colors.dart';

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({
    super.key,
    required this.imageHint,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.circular = false,
  });

  final String imageHint;

  /// Explicit image source (http(s) URL or bundled asset path). When set it
  /// takes precedence over the legacy [imageHint] lookup.
  final String? imageUrl;

  final double? width;
  final double? height;
  final BoxFit fit;
  final bool circular;

  static const placeholderAsset = 'assets/icons/product_placeholder.svg';

  static const _assets = {
    'table': 'assets/showcase/piece_oak_table.jpg',
    'sofa': 'assets/showcase/piece_linen_sofa.jpg',
    'light': 'assets/showcase/piece_brass_pendant.jpg',
    'wardrobe': 'assets/showcase/piece_wardrobe.jpg',
    'rug': 'assets/showcase/piece_wool_rug.jpg',
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

  static bool _isNetwork(String source) =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded =
            constraints.hasBoundedWidth && constraints.hasBoundedHeight;
        if (!bounded) return _picture();
        if (circular) {
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
        }
        if (fit == BoxFit.cover && width == null && height == null) {
          return SizedBox.expand(child: _picture(cover: true));
        }
        return Center(
          child: _picture(cover: false),
        );
      },
    );
  }

  Widget _picture({bool cover = false}) {
    final imageFit = cover ? BoxFit.cover : fit;
    final fallback = _ArtworkFallback(width: width, height: height);
    final source = imageUrl;

    // Prefer an explicit network URL when provided.
    if (source != null && source.isNotEmpty && _isNetwork(source)) {
      return Image.network(
        source,
        width: cover ? null : width,
        height: cover ? null : height,
        fit: imageFit,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    // Otherwise resolve to a bundled asset: explicit asset path first,
    // then the legacy hint lookup.
    final asset = (source != null && source.isNotEmpty)
        ? source
        : assetFor(imageHint);

    if (_isRaster(asset)) {
      return Image.asset(
        asset,
        width: cover ? null : width,
        height: cover ? null : height,
        fit: imageFit,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    return SvgPicture.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (_) => fallback,
      errorBuilder: (context, error, stackTrace) => fallback,
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
