class SupportQuery {
  const SupportQuery({
    required this.id,
    required this.accountId,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    this.projectId,
    this.orderId,
    this.queueLabel,
  });

  final String id;
  final String accountId;
  final String? projectId;
  final String? orderId;
  final String subject;
  final String message;
  final String status;
  final String? queueLabel;
  final DateTime createdAt;

  String get contextLabel {
    if (projectId != null) return 'Project';
    if (orderId != null) return 'Order';
    return 'Support';
  }
}

class SupportContextOption {
  const SupportContextOption.project({required this.id, required this.label})
    : kind = SupportContextKind.project;
  const SupportContextOption.order({required this.id, required this.label})
    : kind = SupportContextKind.order;

  final SupportContextKind kind;
  final String id;
  final String label;

  @override
  bool operator ==(Object other) =>
      other is SupportContextOption && other.kind == kind && other.id == id;

  @override
  int get hashCode => Object.hash(kind, id);
}

enum SupportContextKind { project, order }

class SupportContexts {
  const SupportContexts({required this.options});
  final List<SupportContextOption> options;
  bool get isEmpty => options.isEmpty;
}
