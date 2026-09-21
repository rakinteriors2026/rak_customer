class ProjectDocument {
  const ProjectDocument({
    required this.id,
    required this.projectId,
    required this.type,
    required this.title,
    required this.assetId,
    required this.createdAt,
  });

  final String id;
  final String projectId;
  final String type;
  final String title;
  final String assetId;
  final DateTime createdAt;

  String get typeLabel => switch (type) {
    'agreement' => 'Agreement',
    'quotation' => 'Quotation',
    'invoice' => 'Invoice',
    _ => type,
  };
}
