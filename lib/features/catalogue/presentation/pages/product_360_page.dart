import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class Product360Page extends StatefulWidget {
  const Product360Page({
    super.key,
    required this.productId,
    required this.productName,
  });

  final String productId;
  final String productName;

  @override
  State<Product360Page> createState() => _Product360PageState();
}

class _Product360PageState extends State<Product360Page> {
  static const _views = [
    ('front', 'assets/photos/product_360_front.png'),
    ('side', 'assets/photos/product_360_side.png'),
    ('back', 'assets/photos/product_360_back.png'),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final view = _views[_index];
    return RakPage(
      title: 'Explore in 360°',
      subtitle: widget.productName,
      onBack: () => context.pop(),
      bottomBar: Material(
        color: AppColors.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(context.s(16)),
            child: RakButton(
              label: 'Back to product',
              style: RakButtonStyle.secondary,
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RakStatusBanner(
              text: 'View ${_index + 1} of 3 · ${view.$1}',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          RakPhoto(asset: view.$2, height: 300),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: RakButton(
                  label: '‹  Previous',
                  style: RakButtonStyle.secondary,
                  onPressed: () => setState(() {
                    _index = (_index + _views.length - 1) % _views.length;
                  }),
                ),
              ),
              SizedBox(width: context.s(12)),
              Expanded(
                child: RakButton(
                  label: 'Next  ›',
                  style: RakButtonStyle.secondary,
                  onPressed: () => setState(() {
                    _index = (_index + 1) % _views.length;
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('See the shape from every side.', style: AppText.screenTitle),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Use Previous and Next to change the view. Dimensions and materials stay the same.',
            style: AppText.body,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}
