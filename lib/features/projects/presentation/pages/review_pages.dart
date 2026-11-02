import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_colors.dart';
import 'package:rak_customer/core/theme/app_scale.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/core/theme/app_text.dart';
import 'package:rak_customer/features/projects/presentation/approval_book.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
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
    final book = sl<ApprovalBook>();
    return ListenableBuilder(
      listenable: book,
      builder: (context, _) {
        final quotation = book.current(projectId, 'quotation');
        final design = book.current(projectId, 'design');
        final history = book.history(projectId);
        final pending = book.pendingCount(projectId);
        if (quotation == null && design == null) {
          return RakPage(
            title: 'Your approvals',
            subtitle: projectName,
            onBack: () => context.pop(),
            child: const AppEmptyState(
              title: 'Nothing published to review',
              message:
                  'Quotations and designs appear here after your RAK team publishes them.',
              icon: Icons.fact_check_outlined,
            ),
          );
        }
        return RakPage(
          title: 'Your approvals',
          subtitle: projectName,
          onBack: () => context.pop(),
          child: ListView(
            padding: context.figPagePadding,
            children: [
              FigText(
                pending == 0
                    ? 'No decisions waiting'
                    : '$pending decision${pending == 1 ? '' : 's'} waiting',
                style: AppText.caption,
              ),
              SizedBox(height: context.s(8)),
              const Divider(height: 1, color: AppColors.line),
              if (quotation != null) ...[
                _QuietLink(
                  title: quotation.title,
                  detail:
                      'Version ${quotation.version} · ₹8,40,000 · ${quotation.statusLabel}',
                  onTap: () =>
                      context.push('/projects/$projectId/review/quotation'),
                ),
                const Divider(height: 1, color: AppColors.line),
              ],
              if (design != null) ...[
                _QuietLink(
                  title: design.title,
                  detail: 'Version ${design.version} · ${design.statusLabel}',
                  onTap: () =>
                      context.push('/projects/$projectId/review/design'),
                ),
                const Divider(height: 1, color: AppColors.line),
              ],
              SizedBox(height: context.s(28)),
              FigText('Previous decisions', style: AppText.caption),
              SizedBox(height: context.s(8)),
              if (history.isEmpty)
                FigText(
                  'Earlier versions will be listed here.',
                  style: AppText.body,
                  color: AppColors.muted,
                )
              else
                for (final item in history) ...[
                  const Divider(height: 1, color: AppColors.line),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.s(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FigText(
                          '${item.title} · Version ${item.version}',
                          style: AppText.label,
                        ),
                        SizedBox(height: context.s(2)),
                        FigText(
                          item.decidedAt == null
                              ? item.statusLabel
                              : '${item.statusLabel} · ${DateFormatter.displayDate(item.decidedAt!)}',
                          style: AppText.caption,
                        ),
                        if (item.comment != null) ...[
                          SizedBox(height: context.s(4)),
                          FigText(item.comment!, style: AppText.body),
                        ],
                      ],
                    ),
                  ),
                ],
              if (history.isNotEmpty)
                const Divider(height: 1, color: AppColors.line),
            ],
          ),
        );
      },
    );
  }
}

class QuotationReviewPage extends StatelessWidget {
  const QuotationReviewPage({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context) {
    final item = sl<ApprovalBook>().current(projectId, 'quotation');
    if (item == null) {
      return RakPage(
        title: 'Review quotation',
        subtitle: 'Not published',
        onBack: () => context.pop(),
        child: const AppEmptyState(
          title: 'No quotation to review',
          message: 'This project does not have a published quotation yet.',
          icon: Icons.description_outlined,
        ),
      );
    }
    final open = item.status == ApprovalStatus.pending;
    return RakPage(
      title: 'Interior works',
      subtitle: 'QT-024 · Version ${item.version}',
      onBack: () => context.pop(),
      bottomBar: open
          ? _QuoteDecisionBar(
              onReject: () =>
                  context.push('/projects/$projectId/review/quotation/reject'),
              onApprove: () =>
                  context.push('/projects/$projectId/review/quotation/approve'),
            )
          : null,
      child: ListView(
        padding: context.figPagePadding,
        children: [
          FigText(
            open ? 'Awaiting your decision' : item.statusLabel,
            style: AppText.caption,
          ),
          SizedBox(height: context.s(8)),
          const FigText('₹8,40,000', style: AppText.display),
          SizedBox(height: context.s(4)),
          const FigText(
            'Total, including applicable taxes',
            style: AppText.caption,
          ),
          SizedBox(height: context.s(28)),
          const FigText('Scope', style: AppText.screenTitle),
          SizedBox(height: context.s(4)),
          const _AmountRow(label: 'Kitchen & cabinetry', value: '₹4,20,000'),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(label: 'Living & bedrooms', value: '₹3,30,000'),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(
            label: 'Installation & finishes',
            value: '₹90,000',
          ),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(28)),
          const FigText('Payment', style: AppText.screenTitle),
          SizedBox(height: context.s(4)),
          const _AmountRow(label: 'On confirmation', value: '40%'),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(label: 'Before installation', value: '40%'),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(label: 'On handover', value: '20%'),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(20)),
          const FigText(
            'Approving this version confirms its scope and price. Payment is collected by RAK after you approve.',
            style: AppText.caption,
          ),
          SizedBox(height: context.s(8)),
          _QuietLink(
            title: 'Read complete quotation',
            detail: 'Published with your project documents',
            onTap: () => context.push('/projects/$projectId/documents'),
          ),
          const Divider(height: 1, color: AppColors.line),
          if (item.version > 1) ...[
            _QuietLink(
              title: 'View version ${item.version - 1}',
              detail: 'Closed. A decision here does not apply.',
              onTap: () => context.push(
                '/projects/$projectId/review/quotation/closed',
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
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
    final item = sl<ApprovalBook>().current(projectId, 'design');
    if (item == null) {
      return RakPage(
        title: 'Review design',
        subtitle: 'Not published',
        onBack: () => context.pop(),
        child: const AppEmptyState(
          title: 'No design to review',
          message: 'This project does not have a published design yet.',
          icon: Icons.architecture_outlined,
        ),
      );
    }
    final open = item.status == ApprovalStatus.pending;
    return RakPage(
      title: 'Living room',
      subtitle: 'Version ${item.version}',
      onBack: () => context.pop(),
      bottomBar: open
          ? _QuoteDecisionBar(
              onReject: () =>
                  context.push('/projects/$projectId/review/design/reject'),
              onApprove: () =>
                  context.push('/projects/$projectId/review/design/approve'),
            )
          : null,
      child: ListView(
        padding: context.figPagePadding,
        children: [
          FigText(
            open ? 'Awaiting your decision' : item.statusLabel,
            style: AppText.caption,
          ),
          SizedBox(height: context.s(10)),
          InkWell(
            onTap: () =>
                context.push('/projects/$projectId/review/design/full'),
            child: const RakPhoto(
              asset: 'assets/photos/living_room_design.png',
              height: 240,
            ),
          ),
          SizedBox(height: context.s(22)),
          FigText(
            'What changed in version ${item.version}',
            style: AppText.screenTitle,
          ),
          SizedBox(height: context.s(4)),
          const _AmountRow(
            label: 'Walkway',
            value: 'Wider beside the sofa',
          ),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(
            label: 'TV storage',
            value: 'Warm oak finish',
          ),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(label: 'Shared by', value: 'RAK design team'),
          const Divider(height: 1, color: AppColors.line),
          const _AmountRow(label: 'Updated', value: '15 Sep 2026'),
          const Divider(height: 1, color: AppColors.line),
          SizedBox(height: context.s(8)),
          _QuietLink(
            title: 'Open full design',
            detail: 'The drawing, larger',
            onTap: () =>
                context.push('/projects/$projectId/review/design/full'),
          ),
          const Divider(height: 1, color: AppColors.line),
          if (item.version > 1) ...[
            _QuietLink(
              title: 'View version ${item.version - 1}',
              detail: 'Closed. A decision here does not apply.',
              onTap: () =>
                  context.push('/projects/$projectId/review/design/closed'),
            ),
            const Divider(height: 1, color: AppColors.line),
          ],
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
      title: 'Living room',
      subtitle: 'Version 3',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakPhoto(
            asset: 'assets/photos/living_room_design.png',
            height: 320,
          ),
          SizedBox(height: context.s(16)),
          const FigText(
            'Natural textures. Room to breathe.',
            style: AppText.screenTitle,
          ),
          SizedBox(height: context.s(4)),
          const FigText(
            'Natural oak, warm neutrals and fitted storage.',
            style: AppText.body,
          ),
          SizedBox(height: context.s(4)),
          const FigText('Revised 15 Sep 2026', style: AppText.caption),
          SizedBox(height: context.s(12)),
          _QuietLink(
            title: 'Ask a question',
            detail: 'About this living room',
            onTap: () {
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
          const Divider(height: 1, color: AppColors.line),
          _QuietLink(
            title: 'Approved designs',
            detail: 'Drawings already ready to build',
            onTap: () => context.push('/projects/$projectId/designs'),
          ),
          const Divider(height: 1, color: AppColors.line),
        ],
      ),
    );
  }
}

class ConfirmApprovalPage extends StatefulWidget {
  const ConfirmApprovalPage({
    super.key,
    required this.projectId,
    required this.kind,
  });

  final String projectId;
  final String kind;

  @override
  State<ConfirmApprovalPage> createState() => _ConfirmApprovalPageState();
}

class _ConfirmApprovalPageState extends State<ConfirmApprovalPage> {
  final _note = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotation = widget.kind == 'quotation';
    final current = sl<ApprovalBook>().current(widget.projectId, widget.kind);
    return RakPage(
      title: quotation ? 'Approve quotation?' : 'Approve design?',
      subtitle: current == null
          ? 'Not published'
          : 'Version ${current.version}',
      onBack: () => context.pop(),
      bottomBar: _FixedBar(
        child: RakButton(
          label: 'Confirm approval',
          onPressed: current == null ||
                  current.status != ApprovalStatus.pending
              ? null
              : () {
                  final error = sl<ApprovalBook>().decide(
                    projectId: widget.projectId,
                    kind: widget.kind,
                    version: current.version,
                    approved: true,
                    comment: _note.text,
                  );
                  if (error != null) {
                    setState(() => _error = error);
                    return;
                  }
                  context.go(
                    '/projects/${widget.projectId}/review/${widget.kind}/approved',
                  );
                },
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
            quotation ? 'Total · ₹8,40,000' : 'Living room · revised layout',
            style: AppText.screenTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          FigText(
            'You are approving version ${current?.version ?? '—'}. An older version cannot be approved in its place.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),
          FigText('Note to your team (optional)', style: AppText.caption),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _note,
            decoration: const InputDecoration(hintText: 'Add a note'),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            FigText(_error!, style: AppText.body, color: AppColors.error),
          ],
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
  String? _error;

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
              : () {
                  final current = sl<ApprovalBook>().current(
                    widget.projectId,
                    widget.kind,
                  );
                  final error = current == null
                      ? 'Nothing has been published for review on this project.'
                      : sl<ApprovalBook>().decide(
                          projectId: widget.projectId,
                          kind: widget.kind,
                          version: current.version,
                          approved: false,
                          comment: _reason.text,
                        );
                  if (error != null) {
                    setState(() => _error = error);
                    return;
                  }
                  context.go(
                    '/projects/${widget.projectId}/review/${widget.kind}/rejected',
                  );
                },
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
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            FigText(_error!, style: AppText.body, color: AppColors.error),
          ],
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

class _QuietLink extends StatelessWidget {
  const _QuietLink({
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.s(16)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FigText(title, style: AppText.label),
                  SizedBox(height: context.s(2)),
                  FigText(detail, style: AppText.caption),
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
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.s(14)),
      child: Row(
        children: [
          Expanded(child: FigText(label, style: AppText.label)),
          SizedBox(width: context.s(12)),
          FigText(value, style: AppText.label),
        ],
      ),
    );
  }
}

class _QuoteDecisionBar extends StatelessWidget {
  const _QuoteDecisionBar({required this.onReject, required this.onApprove});

  final VoidCallback onReject;
  final VoidCallback onApprove;

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
            context.s(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RakButton(label: 'Approve', onPressed: onApprove),
              TextButton(onPressed: onReject, child: const Text('Reject')),
            ],
          ),
        ),
      ),
    );
  }
}

class ClosedApprovalPage extends StatelessWidget {
  const ClosedApprovalPage({
    super.key,
    required this.projectId,
    required this.kind,
    required this.version,
  });

  final String projectId;
  final String kind;
  final int version;

  @override
  Widget build(BuildContext context) {
    final latest = sl<ApprovalBook>().current(projectId, kind);
    return RakPage(
      title: 'Version $version',
      subtitle: 'This version is closed',
      onBack: () => context.pop(),
      child: ListView(
        padding: context.figPagePadding,
        children: [
          const RakStatusBanner(text: 'Outdated version'),
          const SizedBox(height: AppSpacing.md),
          FigText(
            latest == null
                ? 'There is no current version to review.'
                : 'A decision on version $version does not approve version ${latest.version}. Review the latest version to record a decision.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.md),
          RakButton(
            label: latest == null ? 'Back' : 'Review version ${latest.version}',
            onPressed: () => context.pop(),
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
