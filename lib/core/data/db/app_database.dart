import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/data/db/converters.dart';
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
  int get schemaVersion => 6;

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
      if (from < 6) {
        await m.addColumn(products, products.imageUrls);
        await m.addColumn(products, products.modelGlbUrl);
        await m.addColumn(products, products.modelUsdzUrl);
        await m.addColumn(products, products.spinFrameUrls);
      }
    },
  );

  /// Seeds local data. The public shop catalogue is always seeded so guests
  /// can browse; the demo accounts and their account-scoped data (projects,
  /// finance, documents, designs, tickets, notifications and the deliberate
  /// cross-account isolation rows) are only seeded when [demoMode] is on.
  ///
  /// [demoMode] defaults to [LocalDemoConfig.demoModeEnabled] so a release
  /// build without `--dart-define=ALLOW_DEMO=true` never creates demo
  /// identities. (F-01)
  Future<void> seedIfNeeded({bool? demoMode}) async {
    final demo = demoMode ?? LocalDemoConfig.demoModeEnabled;
    final existing = await (select(
      appMeta,
    )..where((row) => row.key.equals('seeded'))).getSingleOrNull();
    if (existing == null) {
      await SeedData.seed(this, demoMode: demo);
    }
    if (demo) {
      await SeedData.seedUpdatesIfNeeded(this);
      await SeedData.seedFinanceIfNeeded(this);
      await SeedData.seedTrackingPhaseIfNeeded(this);
    }
    await SeedData.seedIndiaLocaleIfNeeded(this);
  }
}
