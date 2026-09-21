import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/entities/asset_access.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';

class AssetAccessLocalDatasource {
  AssetAccessLocalDatasource({
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
      throw const NotFoundFailure('This file is no longer available.');
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
