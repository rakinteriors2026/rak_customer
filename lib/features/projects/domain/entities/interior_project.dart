class InteriorProject {
  const InteriorProject({
    required this.id,
    required this.name,
    required this.siteLabel,
    required this.phaseCode,
    required this.phaseLabel,
    required this.progressPercent,
    required this.targetHandoverAt,
    required this.forecastHandoverAt,
    required this.updatedAt,
    this.milestones = const [],
  });

  final String id;
  final String name;
  final String siteLabel;
  final String phaseCode;
  final String phaseLabel;
  final int? progressPercent;
  final DateTime? targetHandoverAt;
  final DateTime? forecastHandoverAt;
  final DateTime updatedAt;
  final List<ProjectMilestone> milestones;
}

class ProjectMilestone {
  const ProjectMilestone({
    required this.id,
    required this.title,
    required this.state,
    required this.sortIndex,
    required this.plannedAt,
    required this.completedAt,
    required this.note,
  });

  final String id;
  final String title;
  final String state;
  final int sortIndex;
  final DateTime? plannedAt;
  final DateTime? completedAt;
  final String? note;

  bool get isCompleted => state == 'completed';
}
