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
      subtitle: 'Explore our work and materials',
      onBack: () => context.pop(),
      bottomBar: _FixedAction(
        child: RakButton(
          label: 'Back to home',
          style: RakButtonStyle.secondary,
          onPressed: () => context.go('/home'),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          FigText('Spaces with a story.', style: AppText.heading),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'A closer look at considered living.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'FEATURED PROJECT  /  01',
            style: AppText.caption.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 1.4,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const RakPhoto(
            asset: 'assets/photos/courtyard_home.png',
            height: 160,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('The Courtyard Home', style: AppText.screenTitle),
          const SizedBox(height: AppSpacing.xs),
          FigText('Warm contemporary', style: AppText.caption),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Explore the project',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push('/sales-kit/story'),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          FigText('Know your materials', style: AppText.title),
          const SizedBox(height: AppSpacing.xs),
          FigText(
            'Finishes, applications and everyday care.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Browse material details',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push('/sales-kit/materials'),
          ),
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
            height: 180,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('A warmer way to come home.', style: AppText.heading),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Natural tones, generous storage and space to breathe.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          const _DetailRow(
            label: 'Scope',
            value: 'Living, kitchen & bedrooms',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _DetailRow(label: 'Style', value: 'Warm contemporary'),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          FigText('The design approach', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Storage follows the walls, leaving the centre open. Oak tones connect the living area with the kitchen.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Materials in this project', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Oak-look laminate · details',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push('/sales-kit/materials'),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Talk to the team about adapting this style to your space.',
            style: AppText.body,
            color: AppColors.muted,
          ),
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
            height: 126,
            radius: 0,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'A warm finish for everyday spaces.',
            style: AppText.screenTitle,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'A decorative laminate surface with an oak-inspired grain. Confirm the final shade using a physical sample.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          const _DetailRow(
            label: 'Common applications',
            value: 'Cabinetry & wall panels',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _DetailRow(label: 'Appearance', value: 'Woodgrain · matte'),
          const SizedBox(height: AppSpacing.sm),
          const _DetailRow(
            label: 'Selection',
            value: 'Brand & grade confirmed in quote',
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          FigText('Care & maintenance', style: AppText.title),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Use a soft, lightly damp cloth. Avoid abrasive cleaners and standing water. Follow the selected manufacturer’s care guide.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Specifications & warranty', style: AppText.title),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Thickness, substrate, certification and warranty depend on the selected product. Ask your consultant for the matching datasheet.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Back to sales kit',
            style: RakButtonStyle.secondary,
            onPressed: () => context.go('/sales-kit'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FigText(label, style: AppText.body, color: AppColors.muted),
        ),
        SizedBox(width: context.s(12)),
        Expanded(
          child: FigText(
            value,
            style: AppText.label,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _FixedAction extends StatelessWidget {
  const _FixedAction({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(padding: EdgeInsets.all(context.s(16)), child: child),
      ),
    );
  }
}
