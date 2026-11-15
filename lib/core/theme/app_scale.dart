import 'dart:math' as math;

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
    // Rows that mix a figScale-sized widget (icon/chip) with scaling text are
    // bounded by the taller of the two, so the card fits at any text/display
    // scale without leaving slack at the design scale.
    double row(double figPx, double textPx) =>
        math.max(s(figPx), textPx * textScale);

    final art = s(140.0);
    final padding = s(16.0); // content padding: top 8 + bottom 8
    final gaps = s(12.0); // inter-element gaps: 3 + 3 + 6
    final name = 36.0 * textScale; // two lines × 18
    final material = row(14.0, 14.0); // sparkle icon + finish text
    final specs = 13.0 * textScale; // dimensions / delivery line
    final price = row(26.0, 16.0); // price text + circular CTA chip

    return art + padding + gaps + name + material + specs + price;
  }
}

extension FigTextStyle on TextStyle {
  /// Type stays at its standard point size.
  /// Spacing and images still scale; letterforms do not.
  TextStyle fig(BuildContext context) => this;
}
