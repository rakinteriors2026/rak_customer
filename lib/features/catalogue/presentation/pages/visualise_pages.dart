import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_info_card.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';
import 'package:rak_customer/shared/widgets/rak_progress_bar.dart';

class VisualiseHubPage extends StatelessWidget {
  const VisualiseHubPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  final String productId;
  final String productName;

  String get _base => '/shop/products/$productId/visualise';

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Make room for it',
      subtitle: '$productName · Natural oak',
      onBack: () => context.pop(),
      bottomBar: _CaptionBar(
        label: 'Back to product',
        caption: 'Explore options · Illustrative previews',
        style: RakButtonStyle.secondary,
        onPressed: () => context.pop(),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          RakPhoto(
            asset: 'assets/photos/visualise_product.png',
            height: 198,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Picture the possibilities.', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Explore every angle, create a room concept, or check the placement in your space.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          _ExperienceButton(
            icon: 'assets/icons/visualise_360.svg',
            label: '360° product view',
            primary: false,
            onPressed: () => context.push(
              '/shop/products/$productId/360',
              extra: productName,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExperienceButton(
            icon: 'assets/icons/visualise_ai.svg',
            label: 'Create an AI room concept',
            primary: true,
            onPressed: () =>
                context.push('$_base/ai/photo', extra: productName),
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExperienceButton(
            icon: 'assets/icons/visualise_ar.svg',
            label: 'Place it in my room · AR',
            primary: false,
            onPressed: () =>
                context.push('$_base/ar/permission', extra: productName),
          ),
        ],
      ),
    );
  }
}

class VisualiseAiPage extends StatefulWidget {
  const VisualiseAiPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.step,
  });

  final String productId;
  final String productName;
  final String step;

  @override
  State<VisualiseAiPage> createState() => _VisualiseAiPageState();
}

class _VisualiseAiPageState extends State<VisualiseAiPage> {
  Timer? _advance;

  String get _base => '/shop/products/${widget.productId}/visualise';

  @override
  void initState() {
    super.initState();
    if (widget.step == 'generating') {
      _advance = Timer(const Duration(milliseconds: 2400), () {
        if (!mounted) return;
        context.pushReplacement('$_base/ai/result');
      });
    }
  }

  @override
  void dispose() {
    _advance?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.step) {
      'ready' => _scaffold(
        title: 'Make it feel like you',
        subtitle: 'STEP 2 OF 3 · STYLE & REVIEW',
        barLabel: 'Generate room concept',
        barCaption: 'Prototype · No photo is uploaded',
        onBar: () => context.push('$_base/ai/generating'),
        children: [
          const RakPhoto(
            asset: 'assets/photos/hero_home.png',
            height: 224,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Living room · Photo ready', style: AppText.label),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'A space that feels like yours',
            detail: 'We’ll keep the room layout and place the selected chair.',
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Selected product: ${widget.productName} Natural oak · Sand fabric',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Change photo',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('$_base/ai/photo'),
          ),
        ],
      ),
      'generating' => _scaffold(
        title: 'Finding your new look',
        subtitle: 'CREATING YOUR ROOM CONCEPT',
        barLabel: 'Cancel preview',
        barCaption: 'This preview uses an illustrative result',
        barStyle: RakButtonStyle.secondary,
        onBar: () => context.go('$_base/ai/ready'),
        children: [
          const RakPhoto(
            asset: 'assets/photos/hero_home.png',
            height: 224,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Bringing your idea into focus', style: AppText.title),
          const SizedBox(height: AppSpacing.md),
          const RakProgressBar(value: 0.67),
          const SizedBox(height: AppSpacing.md),
          FigText(
            '✓ Photo checked\n✓ Style selected\nCreating your room concept…',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Sample preview · This prototype will show an illustrative result.',
            style: AppText.caption,
          ),
        ],
      ),
      'result' => _scaffold(
        title: 'A new perspective',
        subtitle: 'STEP 3 OF 3 · YOUR ROOM CONCEPT',
        barLabel: 'Save this concept',
        barCaption: 'Saved within this prototype only',
        onBar: () => context.push('$_base/saved'),
        children: [
          const RakPhoto(
            asset: 'assets/photos/ai_room_result.png',
            height: 264,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('SAMPLE AI CONCEPT', style: AppText.caption),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'An idea to sit with',
            detail: 'Scale, finish and placement are illustrative samples.',
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Concept imagery is illustrative. Product shape, finish and scale may vary; confirm details before ordering.',
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Try a different photo',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('$_base/ai/photo'),
          ),
        ],
      ),
      'upload-error' => _scaffold(
        title: 'Let’s try another photo',
        subtitle: 'PHOTO COULDN’T BE ADDED',
        barLabel: 'Choose another photo',
        barCaption: 'Your other saved concepts are safe',
        onBar: () => context.go('$_base/ai/photo'),
        children: [
          FigText('This photo couldn’t be opened', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Try a JPG or PNG under 10 MB. If the upload was interrupted, check your connection and choose the photo again.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'A clearer view, a better idea',
            detail:
                'Stand in a corner. Keep the room well lit and avoid people in the photo.',
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Use a sample room',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('$_base/ai/ready'),
          ),
        ],
      ),
      'generation-error' => _scaffold(
        title: 'Your room is still here',
        subtitle: 'CONCEPT COULDN’T BE CREATED',
        barLabel: 'Try again',
        barCaption: 'Your photo and style choices are retained',
        onBar: () => context.go('$_base/ai/generating'),
        children: [
          FigText('We couldn’t finish this concept', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'The connection was interrupted. Try again using the same photo and style, or choose another room photo.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'Nothing is lost',
            detail: 'Your selected photo and product stay on this device.',
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Choose a different photo',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('$_base/ai/photo'),
          ),
        ],
      ),
      _ => _scaffold(
        title: 'Your room, reimagined',
        subtitle: 'STEP 1 OF 3 · ADD A PHOTO',
        barLabel: 'Use a sample room',
        barCaption: 'Prototype: selected photo is a sample',
        barStyle: RakButtonStyle.secondary,
        onBar: () => context.push('$_base/ai/ready'),
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(context.s(24)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.s(AppRadii.card)),
              border: Border.all(
                color: AppColors.line,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/icons/visualise_upload.svg',
                  width: context.s(48),
                  height: context.s(48),
                ),
                const SizedBox(height: AppSpacing.sm),
                FigText('Start with a room photo', style: AppText.title),
                const SizedBox(height: AppSpacing.xs),
                FigText(
                  'Choose a bright, wide photo with the floor and walls visible.',
                  style: AppText.body,
                  color: AppColors.muted,
                ),
                const SizedBox(height: AppSpacing.xs),
                FigText('JPG or PNG · Up to 10 MB', style: AppText.caption),
                const SizedBox(height: AppSpacing.md),
                RakButton(
                  label: 'Choose a photo',
                  onPressed: () => context.push('$_base/ai/ready'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'A clearer view, a better idea',
            detail:
                'Stand in a corner. Keep the room well lit and avoid people in the photo.',
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Only your selected photo is used. Nothing is shared automatically.',
            style: AppText.caption,
          ),
        ],
      ),
    };
  }

  Widget _scaffold({
    required String title,
    required String subtitle,
    required String barLabel,
    required String barCaption,
    required VoidCallback onBar,
    required List<Widget> children,
    RakButtonStyle barStyle = RakButtonStyle.primary,
  }) {
    return RakPage(
      title: title,
      subtitle: subtitle,
      onBack: () => context.pop(),
      bottomBar: _CaptionBar(
        label: barLabel,
        caption: barCaption,
        style: barStyle,
        onPressed: onBar,
      ),
      child: ListView(padding: context.figPagePadding, children: children),
    );
  }
}

class VisualiseArPage extends StatelessWidget {
  const VisualiseArPage({
    super.key,
    required this.productId,
    required this.productName,
    required this.step,
  });

  final String productId;
  final String productName;
  final String step;

  String get _base => '/shop/products/$productId/visualise';

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      'scan' => _scaffold(
        context,
        title: 'Find a place for it',
        subtitle: 'STEP 1 OF 2 · SCAN THE FLOOR',
        barLabel: 'Place chair on the floor',
        barCaption: 'Example floor detection · Not live tracking',
        onBar: () => context.push('$_base/ar/place'),
        children: [
          const RakPhoto(
            asset: 'assets/photos/ar_scan.png',
            height: 326,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Move your phone slowly', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Point at a clear, well-lit floor. Keep the camera steady until the placement guide appears.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Floor guide shown · Tap below to place the chair',
            style: AppText.caption,
          ),
        ],
      ),
      'place' || 'rotated' => _scaffold(
        context,
        title: 'Find your perfect angle',
        subtitle: 'STEP 2 OF 2 · PLACE & ROTATE',
        barLabel: 'Save this view',
        barCaption: 'Product appearance, placement and scale are illustrative.',
        onBar: () => context.push('$_base/saved'),
        children: [
          RakPhoto(
            asset: step == 'rotated'
                ? 'assets/photos/ar_rotated.png'
                : 'assets/photos/ar_place.png',
            height: 326,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            step == 'rotated'
                ? '$productName · 45° angle'
                : '$productName · Front view',
            style: AppText.label,
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Compare the angle before you save. W 72 × D 78 × H 82 cm · Confirm clearance.',
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: RakButton(
                  label: 'Rotate 45°',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.push('$_base/ar/rotated'),
                ),
              ),
              SizedBox(width: context.s(12)),
              Expanded(
                child: RakButton(
                  label: 'Reset',
                  style: RakButtonStyle.secondary,
                  onPressed: () => context.go('$_base/ar/place'),
                ),
              ),
            ],
          ),
        ],
      ),
      'denied' => _scaffold(
        context,
        title: 'Camera access is off',
        subtitle: 'YOU’RE IN CONTROL',
        barLabel: 'Try camera access again',
        barCaption: 'This prototype does not change settings',
        onBar: () => context.go('$_base/ar/permission'),
        children: [
          FigText('Allow access when you’re ready', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Camera access is needed to preview placement. You can try again, or continue exploring product angles without it.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'Your camera, your choice',
            detail: 'AR preview stays on this device and is not recorded.',
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Continue with 360° view',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push(
              '/shop/products/$productId/360',
              extra: productName,
            ),
          ),
        ],
      ),
      'unsupported' => _scaffold(
        context,
        title: 'A different way to explore',
        subtitle: 'AR ISN’T AVAILABLE HERE',
        barLabel: 'Create an AI room concept',
        barCaption: 'You can still browse all product angles',
        onBar: () => context.go('$_base/ai/photo'),
        children: [
          FigText('Your device doesn’t support AR', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'You can still explore the chair in 360° or create a room concept from a photo of your space.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'Other ways to visualise',
            detail: '360° views and AI room concepts work without AR.',
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Explore product in 360°',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push(
              '/shop/products/$productId/360',
              extra: productName,
            ),
          ),
        ],
      ),
      'lost' => _scaffold(
        context,
        title: 'Let’s find the floor again',
        subtitle: 'PLACEMENT PAUSED',
        barLabel: 'Scan the floor again',
        barCaption: 'Your product selection is retained',
        onBar: () => context.go('$_base/ar/scan'),
        children: [
          const RakPhoto(
            asset: 'assets/photos/ar_scan.png',
            height: 326,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Tracking paused', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Move back toward the last position and point at the floor. More light may help us find the surface.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Use 360° view instead',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push(
              '/shop/products/$productId/360',
              extra: productName,
            ),
          ),
        ],
      ),
      _ => _scaffold(
        context,
        title: 'See it in your space',
        subtitle: 'AUGMENTED REALITY PREVIEW',
        barLabel: 'Allow camera & continue',
        barCaption: 'Prototype · No live camera is accessed',
        onBar: () => context.push('$_base/ar/scan'),
        children: [
          const RakPhoto(
            asset: 'assets/photos/hero_home.png',
            height: 204,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('A better feel for the fit', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Use your camera to find a clear floor area and preview the chair in your room.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'Illustrative placement',
            detail: 'This preview does not measure your room or save video.',
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Not now · use 360° view',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push(
              '/shop/products/$productId/360',
              extra: productName,
            ),
          ),
        ],
      ),
    };
  }

  Widget _scaffold(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String barLabel,
    required String barCaption,
    required VoidCallback onBar,
    required List<Widget> children,
    RakButtonStyle barStyle = RakButtonStyle.primary,
  }) {
    return RakPage(
      title: title,
      subtitle: subtitle,
      onBack: () => context.pop(),
      bottomBar: _CaptionBar(
        label: barLabel,
        caption: barCaption,
        style: barStyle,
        onPressed: onBar,
      ),
      child: ListView(padding: context.figPagePadding, children: children),
    );
  }
}

class VisualiseSavedPage extends StatelessWidget {
  const VisualiseSavedPage({
    super.key,
    required this.productId,
    required this.productName,
  });

  final String productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'A little inspiration, saved',
      subtitle: 'YOUR ROOM COLLECTION',
      onBack: () => context.pop(),
      bottomBar: _CaptionBar(
        label: 'View product details',
        caption: 'Prototype · No actual photo file is saved',
        onPressed: () => context.go('/shop/products/$productId'),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakPhoto(
            asset: 'assets/photos/ai_room_result.png',
            height: 264,
            radius: AppRadii.card,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            '✓ Saved to your room collection',
            style: AppText.label,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakInfoCard(
            title: 'Kept with this product',
            detail: 'Open Visualise again any time to try another view.',
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Your original product details stay available. Review dimensions and finishes before ordering.',
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Explore another view',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('/shop/products/$productId/visualise'),
          ),
        ],
      ),
    );
  }
}

class _ExperienceButton extends StatelessWidget {
  const _ExperienceButton({
    required this.icon,
    required this.label,
    required this.primary,
    required this.onPressed,
  });

  final String icon;
  final String label;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final background = primary ? AppColors.buttonPrimary : AppColors.soft;
    final foreground = primary ? AppColors.onPrimary : AppColors.ink;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(context.s(AppRadii.button)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.s(AppRadii.button)),
        child: SizedBox(
          height: context.s(52),
          child: Padding(
            padding: EdgeInsets.fromLTRB(context.s(16), 0, context.s(8), 0),
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  width: context.s(24),
                  height: context.s(24),
                ),
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppText.label
                        .fig(context)
                        .copyWith(color: foreground),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptionBar extends StatelessWidget {
  const _CaptionBar({
    required this.label,
    required this.caption,
    required this.onPressed,
    this.style = RakButtonStyle.primary,
  });

  final String label;
  final String caption;
  final VoidCallback onPressed;
  final RakButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(context.s(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RakButton(label: label, style: style, onPressed: onPressed),
              SizedBox(height: context.s(8)),
              FigText(caption, style: AppText.caption),
            ],
          ),
        ),
      ),
    );
  }
}
