import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_radii.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/shared/widgets/fig_text.dart';
import 'package:rak_customer/shared/widgets/rak_button.dart';
import 'package:rak_customer/shared/widgets/rak_page.dart';
import 'package:rak_customer/shared/widgets/rak_photo.dart';
import 'package:rak_customer/shared/widgets/rak_status_banner.dart';

class ReviewCentrePage extends StatelessWidget {
  const ReviewCentrePage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Your approvals',
      subtitle: projectName,
      onBack: () => context.pop(),
      bottomBar: _FixedBar(
        child: RakButton(
          label: 'Back to my project',
          style: RakButtonStyle.secondary,
          onPressed: () => context.go('/projects'),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RakStatusBanner(text: '2 decisions need your attention'),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Review the details at your own pace. Your decision goes directly to your RAK team.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          _ApprovalCard(
            title: 'Interior quotation',
            detail: 'Version 4 · ₹8,40,000',
            action: 'Review quotation',
            onPressed: () =>
                context.push('/projects/$projectId/review/quotation'),
          ),
          const SizedBox(height: AppSpacing.md),
          _ApprovalCard(
            title: 'Living room design',
            detail: 'Version 3 · Updated layout',
            action: 'Review design',
            onPressed: () => context.push('/projects/$projectId/review/design'),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          FigText('Previous decisions', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Kitchen layout · Version 2\nApproved · 12 Aug 2026',
            style: AppText.body,
          ),
        ],
      ),
    );
  }
}

class QuotationReviewPage extends StatelessWidget {
  const QuotationReviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Review quotation',
      subtitle: 'QT-024 · Version 4',
      onBack: () => context.pop(),
      bottomBar: _DecisionBar(
        onReject: () =>
            context.push('/projects/$projectId/review/quotation/reject'),
        onApprove: () =>
            context.push('/projects/$projectId/review/quotation/approve'),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: RakStatusBanner(text: 'Awaiting your decision'),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Interior works', style: AppText.screenTitle),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Please review the scope, amount and payment milestones before you approve.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          const _LineItem(label: 'Kitchen & cabinetry', value: '₹4,20,000'),
          const SizedBox(height: AppSpacing.sm),
          const _LineItem(label: 'Living & bedrooms', value: '₹3,30,000'),
          const SizedBox(height: AppSpacing.sm),
          const _LineItem(label: 'Installation & finishes', value: '₹90,000'),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: AppSpacing.md),
          const _LineItem(
            label: 'Total incl. applicable taxes',
            value: '₹8,40,000',
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Payment milestones', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            '40% on confirmation · 40% before installation · 20% on handover.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Read complete quotation',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push(
              '/projects/$projectId/documents',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Approving this version confirms its scope and price. Payment is collected by RAK after you approve.',
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class DesignReviewPage extends StatelessWidget {
  const DesignReviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Review design',
      subtitle: 'Living room · Version 3',
      onBack: () => context.pop(),
      bottomBar: _DecisionBar(
        onReject: () =>
            context.push('/projects/$projectId/review/design/reject'),
        onApprove: () =>
            context.push('/projects/$projectId/review/design/approve'),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: RakStatusBanner(text: 'Awaiting your decision'),
          ),
          const SizedBox(height: AppSpacing.md),
          const RakPhoto(
            asset: 'assets/photos/living_room_design.png',
            height: 180,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Living room', style: AppText.screenTitle),
          const SizedBox(height: AppSpacing.sm),
          FigText('What changed in version 3', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Wider walkway beside the sofa.\nTV storage revised to a warm oak finish.',
            style: AppText.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          const _LineItem(
            label: 'Shared by',
            value: 'RAK design team',
          ),
          const SizedBox(height: AppSpacing.sm),
          const _LineItem(label: 'Updated', value: '15 Sep 2026'),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Open full design',
            style: RakButtonStyle.secondary,
            onPressed: () =>
                context.push('/projects/$projectId/review/design/full'),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Review the layout and finishes. Use Reject to explain what needs to change.',
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class DesignFullViewPage extends StatelessWidget {
  const DesignFullViewPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: 'Living room · v3',
      subtitle: 'Awaiting your decision',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakPhoto(
            asset: 'assets/photos/living_room_design.png',
            height: 290,
          ),
          const SizedBox(height: AppSpacing.md),
          const RakStatusBanner(text: 'Revised design · 15 Sep 2026'),
          const SizedBox(height: AppSpacing.md),
          FigText('Natural textures. Room to breathe.', style: AppText.title),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'Living room · Natural oak, warm neutrals and fitted storage.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Ask a question',
            style: RakButtonStyle.secondary,
            onPressed: () {
              final uri = Uri(
                path: '/support',
                queryParameters: {
                  'subject': 'Living room · Version 3',
                  'message':
                      'I have a question about the revised living room design.',
                },
              );
              context.go(uri.toString());
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          RakButton(
            label: 'Approved designs',
            style: RakButtonStyle.secondary,
            onPressed: () => context.push('/projects/$projectId/designs'),
          ),
        ],
      ),
    );
  }
}

class ConfirmApprovalPage extends StatelessWidget {
  const ConfirmApprovalPage({
    super.key,
    required this.projectId,
    required this.kind,
  });

  final String projectId;
  final String kind;

  bool get _quotation => kind == 'quotation';

  @override
  Widget build(BuildContext context) {
    return RakPage(
      title: _quotation ? 'Approve quotation?' : 'Approve design?',
      subtitle: _quotation ? 'QT-024 · Version 4' : 'Living room · Version 3',
      onBack: () => context.pop(),
      bottomBar: _FixedBar(
        child: RakButton(
          label: 'Confirm approval',
          onPressed: () => context.go(
            '/projects/$projectId/review/$kind/approved',
          ),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: RakStatusBanner(text: 'Confirm your decision'),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            _quotation ? 'Total · ₹8,40,000' : 'Living room · revised layout',
            style: AppText.screenTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'You are approving this exact version. Your RAK team will be notified and will proceed with this scope.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Note to your team (optional)', style: AppText.caption),
          const SizedBox(height: AppSpacing.xs),
          const TextField(decoration: InputDecoration(hintText: 'Add a note')),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Need a change? Go back and choose Reject to tell the team what to revise.',
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Go back',
            style: RakButtonStyle.secondary,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class RejectDecisionPage extends StatefulWidget {
  const RejectDecisionPage({
    super.key,
    required this.projectId,
    required this.kind,
  });

  final String projectId;
  final String kind;

  @override
  State<RejectDecisionPage> createState() => _RejectDecisionPageState();
}

class _RejectDecisionPageState extends State<RejectDecisionPage> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotation = widget.kind == 'quotation';
    return RakPage(
      title: 'What needs to change?',
      subtitle: quotation ? 'QT-024 · Version 4' : 'Living room · Version 3',
      onBack: () => context.pop(),
      bottomBar: _FixedBar(
        child: RakButton(
          label: 'Submit rejection',
          onPressed: _reason.text.trim().isEmpty
              ? null
              : () => context.go(
                  '/projects/${widget.projectId}/review/${widget.kind}/rejected',
                ),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          FigText(
            'Your feedback helps the team prepare the next version.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Reason for rejection *', style: AppText.label),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _reason,
            minLines: 3,
            maxLines: 6,
            maxLength: 1000,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Tell the team what to revise',
            ),
          ),
          FigText(
            'Required · up to 1,000 characters',
            style: AppText.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'The current version will be marked Rejected. Your reason will be shared with your RAK team.',
            style: AppText.body,
            color: AppColors.muted,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: 'Keep reviewing',
            style: RakButtonStyle.secondary,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class DecisionResultPage extends StatelessWidget {
  const DecisionResultPage({
    super.key,
    required this.projectId,
    required this.kind,
    required this.approved,
  });

  final String projectId;
  final String kind;
  final bool approved;

  @override
  Widget build(BuildContext context) {
    final quotation = kind == 'quotation';
    return RakPage(
      title: approved
          ? (quotation ? 'Quotation approved' : 'Design approved')
          : (quotation ? 'Quotation rejected' : 'Design rejected'),
      subtitle: quotation ? 'QT-024 · Version 4' : 'Living room · Version 3',
      onBack: () => context.go('/projects/$projectId/review'),
      bottomBar: _FixedBar(
        child: RakButton(
          label: 'Back to approvals',
          style: RakButtonStyle.secondary,
          onPressed: () => context.go('/projects/$projectId/review'),
        ),
      ),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RakStatusBanner(
              text: approved ? '✓  Approved' : 'Rejected',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FigText(
            'Your decision has been recorded.',
            style: AppText.heading,
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            approved
                ? 'Your RAK project team has been notified.'
                : 'The team will prepare a revised version from your notes.',
            style: AppText.body,
          ),
        ],
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.title,
    required this.detail,
    required this.action,
    required this.onPressed,
  });

  final String title;
  final String detail;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.s(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.s(AppRadii.banner)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FigText(title, style: AppText.title),
          SizedBox(height: context.s(12)),
          FigText(detail, style: AppText.body, color: AppColors.muted),
          SizedBox(height: context.s(12)),
          RakButton(
            label: action,
            style: RakButtonStyle.secondary,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({required this.label, required this.value});

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

class _DecisionBar extends StatelessWidget {
  const _DecisionBar({required this.onReject, required this.onApprove});

  final VoidCallback onReject;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return _FixedBar(
      child: Row(
        children: [
          Expanded(
            child: RakButton(
              label: 'Reject',
              style: RakButtonStyle.secondary,
              onPressed: onReject,
            ),
          ),
          SizedBox(width: context.s(12)),
          Expanded(
            child: RakButton(label: 'Approve', onPressed: onApprove),
          ),
        ],
      ),
    );
  }
}

class _FixedBar extends StatelessWidget {
  const _FixedBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.s(16),
            context.s(16),
            context.s(16),
            context.s(16),
          ),
          child: child,
        ),
      ),
    );
  }
}
