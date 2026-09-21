import 'package:drift/drift.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';

class UpdatesLocalDatasource {
  UpdatesLocalDatasource({
    required AppDatabase db,
    required Clock clock,
    Duration? accessTtl,
  }) : _db = db,
       _clock = clock,
       _accessTtl = accessTtl ?? LocalDemoConfig.assetAccessTtl;

  final AppDatabase _db;
  final Clock _clock;
  final Duration _accessTtl;
  final Map<String, AssetAccess> _sessionAccess = {};

  void dropCachedAccess(String assetId) => _sessionAccess.remove(assetId);

  Future<PageResult<SiteUpdate>> listPublished({
    required String accountId,
    required String projectId,
    String? cursor,
    int pageSize = 20,
  }) async {
    final owned =
        await (_db.select(_db.projects)..where(
              (t) => t.id.equals(projectId) & t.accountId.equals(accountId),
            ))
            .getSingleOrNull();
    if (owned == null) {
      throw const NotFoundFailure('This project is not available.');
    }

    final query = _db.select(_db.siteUpdates)
      ..where((t) => t.projectId.equals(projectId) & t.published.equals(true))
      ..orderBy([(t) => OrderingTerm.desc(t.sortCursor)])
      ..limit(pageSize);
    if (cursor != null) {
      query.where((t) => t.sortCursor.isSmallerThanValue(cursor));
    }

    final rows = await query.get();
    final items = <SiteUpdate>[];
    for (final row in rows) {
      final links =
          await (_db.select(_db.siteUpdateAssets)
                ..where((t) => t.updateId.equals(row.id))
                ..orderBy([(t) => OrderingTerm.asc(t.sortIndex)]))
              .get();
      items.add(
        SiteUpdate(
          id: row.id,
          projectId: row.projectId,
          published: row.published,
          note: row.note,
          eventAt: row.eventAt,
          sortCursor: row.sortCursor,
          assets: links
              .map(
                (link) => SiteUpdateAssetRef(
                  assetId: link.assetId,
                  sortIndex: link.sortIndex,
                ),
              )
              .toList(),
        ),
      );
    }

    return PageResult(
      items: items,
      nextCursor: items.length == pageSize ? items.last.sortCursor : null,
    );
  }

  Future<AssetAccess> requestAccess(String assetId) async {
    final now = _clock.now().toUtc();
    final cached = _sessionAccess[assetId];
    if (cached != null && !cached.isExpiredAt(now)) {
      return cached;
    }
    _sessionAccess.remove(assetId);

    final row = await (_db.select(
      _db.assets,
    )..where((t) => t.id.equals(assetId))).getSingleOrNull();
    if (row == null || !row.published || row.withdrawn) {
      throw const NotFoundFailure('This photo is no longer available.');
    }

    final access = AssetAccess(
      assetId: row.id,
      signedUrl: 'local-asset://${row.id}?t=${now.microsecondsSinceEpoch}',
      expiresAt: now.add(_accessTtl),
      visualHint: row.visualHint,
      caption: row.caption,
    );
    _sessionAccess[assetId] = access;
    return access;
  }
}
