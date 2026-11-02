import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_layout.dart';

/// Maps Figma's 390-wide frame onto the current device.
///
/// Portrait phones scale from width so image aspect ratios stay exact.
/// Landscape uses the shortest side so headers and action bars are not
/// inflated past the available height.
class AppScale {
  static double of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final reference = size.aspectRatio > 1 ? size.shortestSide : size.width;
    return reference / AppLayout.designWidth;
  }

  static double s(BuildContext context, double px) => px * of(context);

  static bool isHeightConstrained(BuildContext context) {
    return MediaQuery.sizeOf(context).height < 560;
  }
}

extension AppScaleX on BuildContext {
  double get figScale => AppScale.of(this);

  double s(double px) => AppScale.s(this, px);

  bool get figHeightConstrained => AppScale.isHeightConstrained(this);

  EdgeInsets get figPagePadding => EdgeInsets.fromLTRB(s(24), 0, s(24), s(24));

  int get productCrossAxisCount {
    return MediaQuery.textScalerOf(this).scale(1) >= 1.6 ? 1 : 2;
  }

  double get productCardExtent {
    final textScale = MediaQuery.textScalerOf(this).scale(1).clamp(1.0, 3.0);
    final art = s(AppLayout.productArtHeight);
    final padding = s(22);
    // Label is 14/18 and caption is 12/16. Type is not width-scaled.
    final name = 18 * textScale * 2;
    final price = 18 * textScale;
    final stock = 16 * textScale;
    final gaps = s(10);
    // Text line boxes can round a fraction taller than the sizes above.
    return art + padding + name + price + stock + gaps + 2;
  }
}

extension FigTextStyle on TextStyle {
  /// Type stays at its standard point size.
  /// Spacing and images still scale; letterforms do not.
  TextStyle fig(BuildContext context) => this;
}
