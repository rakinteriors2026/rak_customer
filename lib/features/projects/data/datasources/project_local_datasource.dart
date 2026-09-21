import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';

class ProjectLocalDatasource {
  ProjectLocalDatasource(this._db);
  final AppDatabase _db;

  Future<List<InteriorProject>> listForAccount(String accountId) async {
    final rows =
        await (_db.select(_db.projects)
              ..where((t) => t.accountId.equals(accountId))
              ..orderBy([(t) => OrderingTerm.asc(t.sortCursor)]))
            .get();
    return Future.wait(rows.map(_mapWithMilestones));
  }

  Future<InteriorProject> getOwned({
    required String accountId,
    required String projectId,
  }) async {
    final row =
        await (_db.select(_db.projects)..where(
              (t) => t.id.equals(projectId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (row == null) {
      throw const NotFoundFailure('This project is not available.');
    }
    return _mapWithMilestones(row);
  }

  Future<InteriorProject> _mapWithMilestones(ProjectRow row) async {
    final milestones =
        await (_db.select(_db.milestones)
              ..where((t) => t.projectId.equals(row.id))
              ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
            .get();
    return InteriorProject(
      id: row.id,
      name: row.name,
      siteLabel: row.siteLabel,
      phaseCode: row.phaseCode,
      phaseLabel: row.phaseLabel,
      progressPercent: row.progressPercent,
      targetHandoverAt: row.targetHandoverAt,
      forecastHandoverAt: row.forecastHandoverAt,
      updatedAt: row.updatedAt,
      milestones: milestones
          .map(
            (m) => ProjectMilestone(
              id: m.id,
              title: m.title,
              state: m.state,
              sortIndex: m.sortIndex,
              plannedAt: m.plannedAt,
              completedAt: m.completedAt,
              note: m.note,
            ),
          )
          .toList(),
    );
  }
}
