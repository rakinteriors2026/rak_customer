import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';

void _openSupport(
  BuildContext context, {
  required String subject,
  required String message,
}) {
  final uri = Uri(
    path: '/support',
    queryParameters: {'subject': subject, 'message': message},
  );
  context.go(uri.toString());
}

class SalesKitPage extends StatelessWidget {
  const SalesKitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'The RAK sales kit',
      subtitle: 'Featured work',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          InkWell(
            onTap: () => context.push('/sales-kit/story'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RakPhoto(
                  asset: 'assets/photos/courtyard_home.png',
                  height: 220,
                ),
                SizedBox(height: context.s(12)),
                const FigText('Featured project', style: AppText.caption),
                SizedBox(height: context.s(4)),
                Row(
                  children: [
                    const Expanded(
                      child: FigText(
                        'The Courtyard Home',
                        style: AppText.screenTitle,
                      ),
                    ),
                    Icon(
                      CupertinoIcons.chevron_right,
                      size: context.s(14),
                      color: AppColors.muted,
                    ),
                  ],
                ),
                SizedBox(height: context.s(2)),
                const FigText(
                  'Warm contemporary · living, kitchen and bedrooms',
                  style: AppText.body,
                ),
              ],
            ),
          ),
          SizedBox(height: context.s(28)),
          const FigText('In this project', style: AppText.caption),
          SizedBox(height: context.s(8)),
          InkWell(
            onTap: () => context.push('/sales-kit/materials'),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.s(8)),
              child: Row(
                children: [
                  const _Thumb(asset: 'assets/photos/oak_laminate.png'),
                  SizedBox(width: context.s(14)),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FigText('Oak-look laminate', style: AppText.label),
                        FigText(
                          'Finish, care and how it is specified',
                          style: AppText.caption,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: context.s(14),
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
        ],
      ),
    );
  }
}

class ProjectStoryPage extends StatelessWidget {
  const ProjectStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'The Courtyard Home',
      subtitle: 'Design concept · Project story',
      onBack: () => context.pop(),
      bottomBar: _FixedAction(
        child: RakButton(
          label: 'Discuss a similar project',
          onPressed: () => _openSupport(
            context,
            subject: 'The Courtyard Home',
            message:
                'I would like to discuss adapting this Courtyard Home style to my space.',
          ),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakPhoto(
            asset: 'assets/photos/courtyard_home.png',
            height: 220,
          ),
          SizedBox(height: context.s(16)),
          const FigText(
            'A warmer way to come home.',
            style: AppText.heading,
          ),
          SizedBox(height: context.s(6)),
          const FigText(
            'Natural tones, generous storage and space to breathe.',
            style: AppText.body,
          ),
          SizedBox(height: context.s(20)),
          const _Spec(label: 'Scope', value: 'Living, kitchen and bedrooms'),
          const Divider(height: 1, color: AppColors.line),
          const _Spec(label: 'Style', value: 'Warm contemporary'),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(22)),
          const FigText('Approach', style: AppText.screenTitle),
          SizedBox(height: context.s(6)),
          const FigText(
            'Storage follows the walls, leaving the centre open. Oak tones connect the living area with the kitchen.',
            style: AppText.body,
          ),
          SizedBox(height: context.s(22)),
          InkWell(
            onTap: () => context.push('/sales-kit/materials'),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.s(8)),
              child: Row(
                children: [
                  const _Thumb(asset: 'assets/photos/oak_laminate.png'),
                  SizedBox(width: context.s(14)),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FigText('Oak-look laminate', style: AppText.label),
                        FigText(
                          'The finish used through this home',
                          style: AppText.caption,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: context.s(14),
                    color: AppColors.muted,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.line),
        ],
      ),
    );
  }
}

class MaterialDetailsPage extends StatelessWidget {
  const MaterialDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Oak-look laminate',
      subtitle: 'Material guide',
      onBack: () => context.pop(),
      bottomBar: _FixedAction(
        child: RakButton(
          label: 'Ask about this material',
          onPressed: () => _openSupport(
            context,
            subject: 'Oak-look laminate',
            message:
                'I would like to confirm the oak-look laminate shade and matching datasheet.',
          ),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakPhoto(
            asset: 'assets/photos/oak_laminate.png',
            height: 200,
          ),
          SizedBox(height: context.s(16)),
          const FigText(
            'A warm finish for everyday spaces.',
            style: AppText.screenTitle,
          ),
          SizedBox(height: context.s(6)),
          const FigText(
            'An oak-inspired grain. Confirm the final shade with a physical sample.',
            style: AppText.body,
          ),
          SizedBox(height: context.s(20)),
          const _Spec(
            label: 'Used for',
            value: 'Cabinetry and wall panels',
          ),
          const Divider(height: 1, color: AppColors.line),
          const _Spec(label: 'Appearance', value: 'Woodgrain, matte'),
          const Divider(height: 1, color: AppColors.line),
          const _Spec(
            label: 'Selection',
            value: 'Brand and grade are confirmed in the quote',
          ),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(22)),
          const FigText('Care', style: AppText.screenTitle),
          SizedBox(height: context.s(6)),
          const FigText(
            'Use a soft, lightly damp cloth. Avoid abrasive cleaners and standing water. Follow the selected manufacturer’s care guide.',
            style: AppText.body,
          ),
          SizedBox(height: context.s(18)),
          const FigText(
            'Thickness, certification and warranty depend on the product chosen. Ask your consultant for the datasheet.',
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FigText(label, style: AppText.caption),
          SizedBox(height: context.s(2)),
          FigText(value, style: AppText.label),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final size = context.s(64);
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.s(12)),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _FixedAction extends StatelessWidget {
  const _FixedAction({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.s(24),
            context.s(12),
            context.s(24),
            context.s(8),
          ),
          child: child,
        ),
      ),
    );
  }
}
