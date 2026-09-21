import 'package:drift/drift.dart';
import 'package:rak_customer/core/config/local_demo_config.dart';
import 'package:rak_customer/core/data/db/app_database.dart';

class SeedData {
  static const projectsAccountId = 'acc_projects';
  static const buyerAccountId = 'acc_buyer';
  static const alBarariId = 'prj_albarari';
  static const difcId = 'prj_difc';
  static const guestCartId = 'cart_guest';

  static Future<void> seed(AppDatabase db) async {
    await db.transaction(() async {
      final now = DateTime.utc(2026, 9, 8, 6, 30);

      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: projectsAccountId,
              phone: LocalDemoConfig.projectsAccountPhone,
              displayName: 'Anjali Menon',
              hasProjects: true,
              createdAt: now.subtract(const Duration(days: 400)),
            ),
          );
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: buyerAccountId,
              phone: LocalDemoConfig.buyerOnlyPhone,
              displayName: 'Rahul Nair',
              hasProjects: false,
              createdAt: now.subtract(const Duration(days: 20)),
            ),
          );

      await db
          .into(db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: alBarariId,
              accountId: projectsAccountId,
              name: 'Panampilly Nagar villa',
              siteLabel: 'Panampilly Nagar, Kochi',
              phaseCode: 'FITOUT',
              phaseLabel: 'Interior fit-out',
              progressPercent: const Value(62),
              targetHandoverAt: Value(DateTime.utc(2026, 12, 15)),
              forecastHandoverAt: Value(DateTime.utc(2027, 1, 20)),
              updatedAt: now.subtract(const Duration(hours: 3)),
              sortCursor: 'c1_albarari',
            ),
          );
      await db
          .into(db.projects)
          .insert(
            ProjectsCompanion.insert(
              id: difcId,
              accountId: projectsAccountId,
              name: 'HSR Layout apartment',
              siteLabel: 'HSR Layout, Bengaluru',
              phaseCode: 'DESIGN_DEV',
              phaseLabel: 'Design development',
              progressPercent: const Value.absent(),
              targetHandoverAt: Value(DateTime.utc(2026, 11, 1)),
              forecastHandoverAt: const Value.absent(),
              updatedAt: now.subtract(const Duration(days: 2)),
              sortCursor: 'c2_difc',
            ),
          );

      await db.batch((batch) {
        batch.insertAll(db.milestones, [
          MilestonesCompanion.insert(
            id: 'ms_ab_1',
            projectId: alBarariId,
            title: 'Design freeze',
            state: 'completed',
            sortIndex: 0,
            plannedAt: Value(DateTime.utc(2026, 3, 10)),
            completedAt: Value(DateTime.utc(2026, 3, 8)),
            note: const Value('Approved drawings issued to site.'),
          ),
          MilestonesCompanion.insert(
            id: 'ms_ab_2',
            projectId: alBarariId,
            title: 'Civil complete',
            state: 'completed',
            sortIndex: 1,
            plannedAt: Value(DateTime.utc(2026, 6, 30)),
            completedAt: Value(DateTime.utc(2026, 7, 4)),
          ),
          MilestonesCompanion.insert(
            id: 'ms_ab_3',
            projectId: alBarariId,
            title: 'Joinery installation',
            state: 'planned',
            sortIndex: 2,
            plannedAt: Value(DateTime.utc(2026, 10, 15)),
            note: const Value('Kitchen and wardrobe packages.'),
          ),
          MilestonesCompanion.insert(
            id: 'ms_ab_4',
            projectId: alBarariId,
            title: 'Handover',
            state: 'planned',
            sortIndex: 3,
            plannedAt: Value(DateTime.utc(2026, 12, 15)),
          ),
          MilestonesCompanion.insert(
            id: 'ms_difc_1',
            projectId: difcId,
            title: 'Concept presentation',
            state: 'planned',
            sortIndex: 0,
            plannedAt: Value(DateTime.utc(2026, 9, 20)),
          ),
          MilestonesCompanion.insert(
            id: 'ms_difc_2',
            projectId: difcId,
            title: 'Detailed design',
            state: 'planned',
            sortIndex: 1,
            plannedAt: Value(DateTime.utc(2026, 10, 18)),
          ),
        ]);
      });

      await db.batch((batch) {
        batch.insertAll(db.categories, [
          CategoriesCompanion.insert(
            id: 'cat_furniture',
            name: 'Furniture',
            sortIndex: 0,
          ),
          CategoriesCompanion.insert(
            id: 'cat_lighting',
            name: 'Lighting',
            sortIndex: 1,
          ),
          CategoriesCompanion.insert(
            id: 'cat_storage',
            name: 'Storage',
            sortIndex: 2,
          ),
          CategoriesCompanion.insert(
            id: 'cat_decor',
            name: 'Decor',
            sortIndex: 3,
          ),
        ]);
        batch.insertAll(db.products, [
          ProductsCompanion.insert(
            id: 'prod_oak_table',
            categoryId: 'cat_furniture',
            name: 'Oak dining table',
            description:
                'Solid European oak, seating eight. Natural oil finish. Made for indoor dining rooms.',
            salesMode: 'fixed_price',
            priceMinor: const Value(1850000),
            specs: 'W 220cm · D 100cm · H 76cm',
            imageHint: 'table',
            sortCursor: 'p1',
          ),
          ProductsCompanion.insert(
            id: 'prod_linen_sofa',
            categoryId: 'cat_furniture',
            name: 'Linen three-seat sofa',
            description:
                'Deep-seat sofa in natural linen with kiln-dried hardwood frame and duck-feather wrap.',
            salesMode: 'fixed_price',
            priceMinor: const Value(920000),
            specs: 'W 230cm · D 98cm · H 82cm',
            imageHint: 'sofa',
            sortCursor: 'p2',
          ),
          ProductsCompanion.insert(
            id: 'prod_brass_pendant',
            categoryId: 'cat_lighting',
            name: 'Brass dome pendant',
            description:
                'Hand-spun brass pendant, made to order. Lead time confirmed at serviceability check.',
            salesMode: 'made_to_order',
            priceMinor: const Value(240000),
            specs: 'Diameter 42cm · drop 150cm max',
            imageHint: 'light',
            sortCursor: 'p3',
          ),
          ProductsCompanion.insert(
            id: 'prod_wardrobe',
            categoryId: 'cat_storage',
            name: 'Walk-in wardrobe',
            description:
                'Bespoke joinery configured to your room. A consultant will quote after site dimensions.',
            salesMode: 'quotation_only',
            specs: 'Custom width · oak or painted finish',
            imageHint: 'wardrobe',
            sortCursor: 'p4',
          ),
          ProductsCompanion.insert(
            id: 'prod_rug',
            categoryId: 'cat_decor',
            name: 'Hand-knotted wool rug',
            description: 'New Zealand wool, low pile, stone and sand palette.',
            salesMode: 'fixed_price',
            priceMinor: const Value(560000),
            specs: '240 × 170cm',
            imageHint: 'rug',
            sortCursor: 'p5',
          ),
        ]);
      });

      await db
          .into(db.carts)
          .insert(CartsCompanion.insert(id: guestCartId, totalMinor: 0));

      await db
          .into(db.appMeta)
          .insert(AppMetaCompanion.insert(key: 'seeded', value: '1'));
      await _insertUpdates(db);
      await _insertFinance(db);
      await _insertTrackingPhase(db);
    });
  }

  static Future<void> seedUpdatesIfNeeded(AppDatabase db) async {
    final existing = await (db.select(
      db.appMeta,
    )..where((row) => row.key.equals('updates_seeded'))).getSingleOrNull();
    if (existing != null) return;
    await db.transaction(() => _insertUpdates(db));
  }

  static Future<void> _insertUpdates(AppDatabase db) async {
    await db.batch((batch) {
      batch.insertAll(db.assets, [
        AssetsCompanion.insert(
          id: 'ast_joinery_1',
          visualHint: 'joinery',
          caption: const Value('Wardrobe carcasses on site'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_joinery_2',
          visualHint: 'joinery',
          caption: const Value('Kitchen carcass ready for doors'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_kitchen_1',
          visualHint: 'kitchen',
          caption: const Value('Stone template complete'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_kitchen_withdrawn',
          visualHint: 'kitchen',
          caption: const Value('Superseded angle'),
          published: true,
          withdrawn: const Value(true),
        ),
        AssetsCompanion.insert(
          id: 'ast_draft_internal',
          visualHint: 'living',
          caption: const Value('Internal QA — do not publish'),
          published: false,
        ),
      ]);
      batch.insertAll(db.siteUpdates, [
        SiteUpdatesCompanion.insert(
          id: 'upd_joinery',
          projectId: alBarariId,
          published: true,
          note: const Value(
            'Joinery package delivered. Installation starts next week.',
          ),
          eventAt: DateTime.utc(2026, 9, 6, 14, 10),
          sortCursor: '009',
        ),
        SiteUpdatesCompanion.insert(
          id: 'upd_note',
          projectId: alBarariId,
          published: true,
          note: const Value(
            'Electrician completed first-fix in the guest suite.',
          ),
          eventAt: DateTime.utc(2026, 8, 28, 9, 0),
          sortCursor: '008',
        ),
        SiteUpdatesCompanion.insert(
          id: 'upd_kitchen',
          projectId: alBarariId,
          published: true,
          note: const Value('Kitchen worktop templating is done.'),
          eventAt: DateTime.utc(2026, 8, 12, 11, 30),
          sortCursor: '007',
        ),
        SiteUpdatesCompanion.insert(
          id: 'upd_draft',
          projectId: alBarariId,
          published: false,
          note: const Value(
            'Internal only: lighting mock-up, not for the client.',
          ),
          eventAt: DateTime.utc(2026, 9, 7, 16, 0),
          sortCursor: '010',
        ),
      ]);
      batch.insertAll(db.siteUpdateAssets, [
        SiteUpdateAssetsCompanion.insert(
          updateId: 'upd_joinery',
          assetId: 'ast_joinery_1',
          sortIndex: 0,
        ),
        SiteUpdateAssetsCompanion.insert(
          updateId: 'upd_joinery',
          assetId: 'ast_joinery_2',
          sortIndex: 1,
        ),
        SiteUpdateAssetsCompanion.insert(
          updateId: 'upd_kitchen',
          assetId: 'ast_kitchen_1',
          sortIndex: 0,
        ),
        SiteUpdateAssetsCompanion.insert(
          updateId: 'upd_kitchen',
          assetId: 'ast_kitchen_withdrawn',
          sortIndex: 1,
        ),
        SiteUpdateAssetsCompanion.insert(
          updateId: 'upd_draft',
          assetId: 'ast_draft_internal',
          sortIndex: 0,
        ),
      ]);
    });
    await db
        .into(db.appMeta)
        .insert(AppMetaCompanion.insert(key: 'updates_seeded', value: '1'));
  }

  static const financeCurrency = 'INR';
  static const totalContractMinor = 185000000;
  static const approvedVariationsMinor = 12000000;
  static const netReceivedMinor = 98000000;
  static const outstandingTotalMinor = 77700000;
  static const amountCurrentlyDueMinor = 25000000;
  static const creditOverpaymentMinor = 1500000;
  static final financeAsOf = DateTime.utc(2026, 9, 6, 8, 0);

  static Future<void> seedFinanceIfNeeded(AppDatabase db) async {
    final existing = await (db.select(
      db.appMeta,
    )..where((row) => row.key.equals('finance_seeded'))).getSingleOrNull();
    if (existing != null) return;
    await db.transaction(() => _insertFinance(db));
  }

  static Future<void> _insertFinance(AppDatabase db) async {
    await db
        .into(db.projectBalances)
        .insert(
          ProjectBalancesCompanion.insert(
            projectId: alBarariId,
            currency: financeCurrency,
            asOf: financeAsOf,
            totalContractMinor: totalContractMinor,
            approvedVariationsMinor: approvedVariationsMinor,
            netReceivedMinor: netReceivedMinor,
            outstandingTotalMinor: outstandingTotalMinor,
            amountCurrentlyDueMinor: amountCurrentlyDueMinor,
            creditOverpaymentMinor: creditOverpaymentMinor,
          ),
        );
    await db.batch((batch) {
      batch.insertAll(db.ledgerEntries, [
        LedgerEntriesCompanion.insert(
          id: 'led_retainer',
          projectId: alBarariId,
          description: 'Design retainer',
          state: 'posted',
          amountMinor: 15000000,
          currency: financeCurrency,
          postedAt: DateTime.utc(2026, 2, 10),
          sortCursor: '001',
        ),
        LedgerEntriesCompanion.insert(
          id: 'led_claim1',
          projectId: alBarariId,
          description: 'Progress claim 1',
          state: 'posted',
          amountMinor: 83000000,
          currency: financeCurrency,
          postedAt: DateTime.utc(2026, 6, 18),
          sortCursor: '002',
        ),
        LedgerEntriesCompanion.insert(
          id: 'led_duplicate',
          projectId: alBarariId,
          description: 'Duplicate receipt — reversed',
          state: 'reversed',
          amountMinor: 5000000,
          currency: financeCurrency,
          postedAt: DateTime.utc(2026, 6, 19),
          sortCursor: '003',
        ),
        LedgerEntriesCompanion.insert(
          id: 'led_variation',
          projectId: alBarariId,
          description: 'Approved joinery variation',
          state: 'posted',
          amountMinor: 12000000,
          currency: financeCurrency,
          postedAt: DateTime.utc(2026, 8, 2),
          sortCursor: '004',
        ),
      ]);
      batch.insertAll(db.dueScheduleItems, [
        DueScheduleItemsCompanion.insert(
          id: 'due_joinery',
          projectId: alBarariId,
          label: 'Stage 3 — joinery',
          amountMinor: 25000000,
          currency: financeCurrency,
          dueAt: DateTime.utc(2026, 10, 1),
          sortIndex: 0,
        ),
        DueScheduleItemsCompanion.insert(
          id: 'due_handover',
          projectId: alBarariId,
          label: 'Handover retention',
          amountMinor: 52700000,
          currency: financeCurrency,
          dueAt: DateTime.utc(2026, 12, 15),
          sortIndex: 1,
        ),
      ]);
    });
    await db
        .into(db.appMeta)
        .insert(AppMetaCompanion.insert(key: 'finance_seeded', value: '1'));
  }

  static const ticketAlBarariId = 'qry_ab_joinery';
  static const foreignTicketId = 'qry_someone_else';
  static const notificationDeniedId = 'ntf_denied';

  static Future<void> seedTrackingPhaseIfNeeded(AppDatabase db) async {
    final existing =
        await (db.select(db.appMeta)
              ..where((row) => row.key.equals('tracking_phase_seeded')))
            .getSingleOrNull();
    if (existing != null) return;
    await db.transaction(() => _insertTrackingPhase(db));
  }

  static Future<void> _insertTrackingPhase(AppDatabase db) async {
    await db.batch((batch) {
      batch.insertAll(db.assets, [
        AssetsCompanion.insert(
          id: 'ast_doc_agreement',
          visualHint: 'pdf',
          caption: const Value('Interior works agreement'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_doc_quote',
          visualHint: 'pdf',
          caption: const Value('Quotation v2'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_doc_invoice',
          visualHint: 'pdf',
          caption: const Value('Progress invoice 1'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_doc_draft',
          visualHint: 'pdf',
          caption: const Value('Internal draft contract'),
          published: false,
        ),
        AssetsCompanion.insert(
          id: 'ast_design_living',
          visualHint: 'living',
          caption: const Value('Living room — approved'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_design_kitchen',
          visualHint: 'kitchen',
          caption: const Value('Kitchen — approved'),
          published: true,
        ),
        AssetsCompanion.insert(
          id: 'ast_design_unapproved',
          visualHint: 'joinery',
          caption: const Value('Option B — not approved'),
          published: true,
        ),
      ]);
      batch.insertAll(db.projectDocuments, [
        ProjectDocumentsCompanion.insert(
          id: 'doc_agreement',
          projectId: alBarariId,
          type: 'agreement',
          title: 'Interior works agreement',
          assetId: 'ast_doc_agreement',
          published: true,
          createdAt: DateTime.utc(2026, 3, 9),
        ),
        ProjectDocumentsCompanion.insert(
          id: 'doc_quote_v2',
          projectId: alBarariId,
          type: 'quotation',
          title: 'Quotation v2',
          assetId: 'ast_doc_quote',
          published: true,
          createdAt: DateTime.utc(2026, 4, 2),
        ),
        ProjectDocumentsCompanion.insert(
          id: 'doc_invoice',
          projectId: alBarariId,
          type: 'invoice',
          title: 'Progress invoice 1',
          assetId: 'ast_doc_invoice',
          published: true,
          createdAt: DateTime.utc(2026, 6, 20),
        ),
        ProjectDocumentsCompanion.insert(
          id: 'doc_draft',
          projectId: alBarariId,
          type: 'agreement',
          title: 'Internal draft contract',
          assetId: 'ast_doc_draft',
          published: false,
          createdAt: DateTime.utc(2026, 3, 1),
        ),
      ]);
      batch.insertAll(db.designs, [
        DesignsCompanion.insert(
          id: 'dsn_living',
          projectId: alBarariId,
          title: 'Living room',
          versionLabel: 'Rev C',
          approved: true,
          published: true,
          sortIndex: 0,
        ),
        DesignsCompanion.insert(
          id: 'dsn_kitchen',
          projectId: alBarariId,
          title: 'Kitchen',
          versionLabel: 'Rev B',
          approved: true,
          published: true,
          sortIndex: 1,
        ),
        DesignsCompanion.insert(
          id: 'dsn_option_b',
          projectId: alBarariId,
          title: 'Joinery option B',
          versionLabel: 'Rev A',
          approved: false,
          published: true,
          sortIndex: 2,
        ),
        DesignsCompanion.insert(
          id: 'dsn_internal',
          projectId: alBarariId,
          title: 'Staff mood board',
          versionLabel: 'WIP',
          approved: true,
          published: false,
          sortIndex: 3,
        ),
      ]);
      batch.insertAll(db.designAssets, [
        DesignAssetsCompanion.insert(
          designId: 'dsn_living',
          assetId: 'ast_design_living',
          sortIndex: 0,
        ),
        DesignAssetsCompanion.insert(
          designId: 'dsn_kitchen',
          assetId: 'ast_design_kitchen',
          sortIndex: 0,
        ),
        DesignAssetsCompanion.insert(
          designId: 'dsn_option_b',
          assetId: 'ast_design_unapproved',
          sortIndex: 0,
        ),
      ]);
      batch.insertAll(db.supportQueries, [
        SupportQueriesCompanion.insert(
          id: ticketAlBarariId,
          accountId: projectsAccountId,
          projectId: const Value(alBarariId),
          subject: 'Joinery delivery window',
          message: 'Please confirm the wardrobe install week.',
          status: 'open',
          queueLabel: const Value('Project coordination'),
          createdAt: DateTime.utc(2026, 9, 5, 10, 0),
        ),
        SupportQueriesCompanion.insert(
          id: foreignTicketId,
          accountId: buyerAccountId,
          orderId: const Value('ord_not_yours'),
          subject: 'Other account ticket',
          message: 'Should never be visible to another account.',
          status: 'open',
          queueLabel: const Value('Order desk'),
          createdAt: DateTime.utc(2026, 9, 4, 8, 0),
        ),
      ]);
      batch.insertAll(db.inAppNotifications, [
        InAppNotificationsCompanion.insert(
          id: 'ntf_finance',
          accountId: projectsAccountId,
          title: 'Payment posted',
          body: 'Progress claim 1 is now on your ledger.',
          targetType: 'project',
          targetId: alBarariId,
          createdAt: DateTime.utc(2026, 6, 18, 12, 0),
        ),
        InAppNotificationsCompanion.insert(
          id: 'ntf_update',
          accountId: projectsAccountId,
          title: 'New site photos',
          body: 'Joinery package photos have been published.',
          targetType: 'project',
          targetId: alBarariId,
          createdAt: DateTime.utc(2026, 9, 6, 14, 15),
        ),
        InAppNotificationsCompanion.insert(
          id: notificationDeniedId,
          accountId: projectsAccountId,
          title: 'Shared link',
          body: 'A document from another account (should be denied).',
          targetType: 'project',
          targetId: 'prj_not_yours',
          createdAt: DateTime.utc(2026, 9, 7, 9, 0),
        ),
        InAppNotificationsCompanion.insert(
          id: 'ntf_buyer',
          accountId: buyerAccountId,
          title: 'Welcome',
          body:
              'You can shop without a project. Support is available once you have an order.',
          targetType: 'none',
          targetId: '',
          createdAt: DateTime.utc(2026, 9, 1),
        ),
      ]);
    });
    await db
        .into(db.appMeta)
        .insert(
          AppMetaCompanion.insert(key: 'tracking_phase_seeded', value: '1'),
        );
  }

  static Future<void> seedIndiaLocaleIfNeeded(AppDatabase db) async {
    final existing = await (db.select(
      db.appMeta,
    )..where((row) => row.key.equals('india_locale'))).getSingleOrNull();
    if (existing != null) return;

    await db.customStatement("UPDATE products SET currency = 'INR'");
    await db.customStatement("UPDATE carts SET currency = 'INR'");
    await db.customStatement("UPDATE cart_items SET currency = 'INR'");
    await db.customStatement("UPDATE project_balances SET currency = 'INR'");
    await db.customStatement("UPDATE ledger_entries SET currency = 'INR'");
    await db.customStatement("UPDATE due_schedule_items SET currency = 'INR'");
    await db.customStatement("UPDATE shop_orders SET currency = 'INR'");
    await db.customStatement("UPDATE shop_order_items SET currency = 'INR'");

    await (db.update(
      db.accounts,
    )..where((row) => row.id.equals(projectsAccountId))).write(
      AccountsCompanion(
        phone: Value(LocalDemoConfig.projectsAccountPhone),
        displayName: const Value('Anjali Menon'),
      ),
    );
    await (db.update(
      db.accounts,
    )..where((row) => row.id.equals(buyerAccountId))).write(
      AccountsCompanion(
        phone: Value(LocalDemoConfig.buyerOnlyPhone),
        displayName: const Value('Rahul Nair'),
      ),
    );
    await (db.update(
      db.projects,
    )..where((row) => row.id.equals(alBarariId))).write(
      const ProjectsCompanion(
        name: Value('Panampilly Nagar villa'),
        siteLabel: Value('Panampilly Nagar, Kochi'),
      ),
    );
    await (db.update(db.projects)..where((row) => row.id.equals(difcId))).write(
      const ProjectsCompanion(
        name: Value('HSR Layout apartment'),
        siteLabel: Value('HSR Layout, Bengaluru'),
      ),
    );

    await db
        .into(db.appMeta)
        .insert(AppMetaCompanion.insert(key: 'india_locale', value: '1'));
  }
}
