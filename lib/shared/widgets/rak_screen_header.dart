import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rak_customer/core/theme/app_layout.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';

class RakScreenHeader extends StatelessWidget {
  const RakScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBack,
    this.contentGap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final double? contentGap;

  @override
  Widget build(BuildContext context) {
    final compact = onBack != null;
    final constrained = context.figHeightConstrained;
    final gap = contentGap ?? (compact ? (constrained ? 12.0 : 32.0) : 26.0);
    return Padding(
      padding: EdgeInsets.only(bottom: context.s(gap)),
      child: compact ? _compact(context) : _page(context),
    );
  }

  Widget _page(BuildContext context) {
    final constrained = context.figHeightConstrained;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.s(24),
        context.s(constrained ? 12 : 24),
        context.s(24),
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FigText(title, style: AppText.heading),
          SizedBox(height: context.s(4)),
          FigText(subtitle, style: AppText.caption),
        ],
      ),
    );
  }

  Widget _compact(BuildContext context) {
    final constrained = context.figHeightConstrained;
    final target = math.max(
      kMinInteractiveDimension,
      context.s(AppLayout.tapTarget),
    );
    return Padding(
      padding: EdgeInsets.only(top: context.s(constrained ? 8 : 18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: context.s(12)),
          SizedBox(
            width: target,
            height: target,
            child: Semantics(
              button: true,
              label: MaterialLocalizations.of(context).backButtonTooltip,
              excludeSemantics: true,
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: onBack,
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  minimumSize: Size(target, target),
                  tapTargetSize: MaterialTapTargetSize.padded,
                  alignment: Alignment.center,
                ),
                icon: Icon(
                  CupertinoIcons.chevron_back,
                  size: context.s(22),
                  color: AppText.heading.color,
                ),
              ),
            ),
          ),
          SizedBox(width: context.s(8)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: context.s(6), right: context.s(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(title, style: AppText.screenTitle),
                  SizedBox(height: context.s(4)),
                  FigText(subtitle, style: AppText.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
