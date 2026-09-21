import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:rak_customer/core/data/db/seed.dart';
import 'package:rak_customer/core/data/db/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    OtpChallenges,
    AuthSessions,
    Projects,
    Milestones,
    Categories,
    Products,
    Carts,
    CartItems,
    SiteUpdates,
    Assets,
    SiteUpdateAssets,
    ProjectBalances,
    LedgerEntries,
    DueScheduleItems,
    ProjectDocuments,
    Designs,
    DesignAssets,
    SupportQueries,
    Devices,
    InAppNotifications,
    DeliveryAddresses,
    ShopOrders,
    ShopOrderItems,
    ProductEnquiries,
    AppMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  static QueryExecutor _open() => driftDatabase(
    name: 'rak_customer',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(siteUpdates);
        await m.createTable(assets);
        await m.createTable(siteUpdateAssets);
      }
      if (from < 3) {
        await m.createTable(projectBalances);
        await m.createTable(ledgerEntries);
        await m.createTable(dueScheduleItems);
      }
      if (from < 4) {
        await m.createTable(projectDocuments);
        await m.createTable(designs);
        await m.createTable(designAssets);
        await m.createTable(supportQueries);
        await m.createTable(devices);
        await m.createTable(inAppNotifications);
      }
      if (from < 5) {
        await m.createTable(deliveryAddresses);
        await m.createTable(shopOrders);
        await m.createTable(shopOrderItems);
        await m.createTable(productEnquiries);
      }
    },
  );

  Future<void> seedIfNeeded() async {
    final existing = await (select(
      appMeta,
    )..where((row) => row.key.equals('seeded'))).getSingleOrNull();
    if (existing == null) {
      await SeedData.seed(this);
    }
    await SeedData.seedUpdatesIfNeeded(this);
    await SeedData.seedFinanceIfNeeded(this);
    await SeedData.seedTrackingPhaseIfNeeded(this);
    await SeedData.seedIndiaLocaleIfNeeded(this);
  }
}
