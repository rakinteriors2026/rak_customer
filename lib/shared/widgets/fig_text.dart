import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_scale.dart';

class FigText extends StatelessWidget {
  const FigText(
    this.data, {
    super.key,
    required this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.color,
  });

  final String data;
  final TextStyle style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scaled = style.fig(context).copyWith(color: color ?? style.color);
    return Text(
      data,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: scaled,
      strutStyle: StrutStyle(
        fontSize: scaled.fontSize,
        height: scaled.height,
        fontFamily: scaled.fontFamily,
        fontWeight: scaled.fontWeight,
        leading: 0,
        forceStrutHeight: true,
      ),
    );
  }
}
