import 'package:flutter/foundation.dart';

enum ApprovalStatus { pending, approved, rejected, revised }

class ApprovalDecision {
  const ApprovalDecision({
    required this.projectId,
    required this.kind,
    required this.version,
    required this.title,
    required this.status,
    this.decidedAt,
    this.comment,
  });

  final String projectId;
  final String kind;
  final int version;
  final String title;
  final ApprovalStatus status;
  final DateTime? decidedAt;
  final String? comment;

  String get statusLabel => switch (status) {
    ApprovalStatus.pending => 'Pending',
    ApprovalStatus.approved => 'Approved',
    ApprovalStatus.rejected => 'Rejected',
    ApprovalStatus.revised => 'Revised',
  };

  ApprovalDecision copyWith({
    ApprovalStatus? status,
    DateTime? decidedAt,
    String? comment,
  }) {
    return ApprovalDecision(
      projectId: projectId,
      kind: kind,
      version: version,
      title: title,
      status: status ?? this.status,
      decidedAt: decidedAt ?? this.decidedAt,
      comment: comment ?? this.comment,
    );
  }
}

/// Session record of quotation and design decisions.
///
/// A decision is stored only against the latest version of that item.
class ApprovalBook extends ChangeNotifier {
  ApprovalBook({DateTime Function()? now}) : _now = now ?? DateTime.now {
    _items.addAll(_seed);
  }

  final DateTime Function() _now;
  final List<ApprovalDecision> _items = [];

  static const villaId = 'prj_albarari';

  static final List<ApprovalDecision> _seed = [
    ApprovalDecision(
      projectId: villaId,
      kind: 'quotation',
      version: 1,
      title: 'Interior quotation',
      status: ApprovalStatus.rejected,
      decidedAt: DateTime.utc(2026, 6, 2),
      comment: 'Kitchen run was too wide for the site.',
    ),
    ApprovalDecision(
      projectId: villaId,
      kind: 'quotation',
      version: 2,
      title: 'Interior quotation',
      status: ApprovalStatus.approved,
      decidedAt: DateTime.utc(2026, 7, 18),
      comment: 'Approved the revised kitchen scope.',
    ),
    ApprovalDecision(
      projectId: villaId,
      kind: 'quotation',
      version: 3,
      title: 'Interior quotation',
      status: ApprovalStatus.revised,
      decidedAt: DateTime.utc(2026, 8, 12),
      comment: 'Living and bedroom allowances were updated.',
    ),
    const ApprovalDecision(
      projectId: villaId,
      kind: 'quotation',
      version: 4,
      title: 'Interior quotation',
      status: ApprovalStatus.pending,
    ),
    ApprovalDecision(
      projectId: villaId,
      kind: 'design',
      version: 1,
      title: 'Living room design',
      status: ApprovalStatus.rejected,
      decidedAt: DateTime.utc(2026, 7, 4),
      comment: 'Walkway beside the sofa was too narrow.',
    ),
    ApprovalDecision(
      projectId: villaId,
      kind: 'design',
      version: 2,
      title: 'Living room design',
      status: ApprovalStatus.revised,
      decidedAt: DateTime.utc(2026, 8, 20),
      comment: 'Superseded by the warm-oak TV storage revision.',
    ),
    const ApprovalDecision(
      projectId: villaId,
      kind: 'design',
      version: 3,
      title: 'Living room design',
      status: ApprovalStatus.pending,
    ),
  ];

  List<ApprovalDecision> forProject(String projectId) {
    return _items.where((item) => item.projectId == projectId).toList();
  }

  ApprovalDecision? current(String projectId, String kind) {
    ApprovalDecision? latest;
    for (final item in _items) {
      if (item.projectId != projectId || item.kind != kind) continue;
      if (latest == null || item.version > latest.version) latest = item;
    }
    return latest;
  }

  List<ApprovalDecision> history(String projectId) {
    return forProject(
      projectId,
    ).where((item) => item.status != ApprovalStatus.pending).toList();
  }

  int pendingCount(String projectId) {
    var count = 0;
    for (final kind in const ['quotation', 'design']) {
      final item = current(projectId, kind);
      if (item != null && item.status == ApprovalStatus.pending) count++;
    }
    return count;
  }

  /// Returns an error message when the decision cannot be stored.
  String? decide({
    required String projectId,
    required String kind,
    required int version,
    required bool approved,
    String? comment,
  }) {
    final latest = current(projectId, kind);
    if (latest == null) {
      return 'Nothing has been published for review on this project.';
    }
    if (version != latest.version) {
      return 'Version $version is outdated. Review version ${latest.version} instead.';
    }
    if (latest.status != ApprovalStatus.pending) {
      return 'Version ${latest.version} is already ${latest.statusLabel.toLowerCase()}.';
    }
    final note = comment?.trim();
    if (!approved && (note == null || note.isEmpty)) {
      return 'Add a reason before rejecting.';
    }
    final index = _items.indexWhere(
      (item) =>
          item.projectId == projectId &&
          item.kind == kind &&
          item.version == version,
    );
    if (index < 0) {
      return 'This version is not available.';
    }
    _items[index] = latest.copyWith(
      status: approved ? ApprovalStatus.approved : ApprovalStatus.rejected,
      decidedAt: _now(),
      comment: note,
    );
    notifyListeners();
    return null;
  }
}
