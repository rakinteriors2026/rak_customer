import 'package:drift/drift.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get phone => text().unique()();
  TextColumn get displayName => text()();
  BoolColumn get hasProjects => boolean()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('OtpChallengeRow')
class OtpChallenges extends Table {
  TextColumn get id => text()();
  TextColumn get phone => text()();
  TextColumn get purpose => text()();
  TextColumn get code => text()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get resendAfter => dateTime()();
  BoolColumn get consumed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AuthSessionRow')
class AuthSessions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProjectRow')
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get name => text()();
  TextColumn get siteLabel => text()();
  TextColumn get phaseCode => text()();
  TextColumn get phaseLabel => text()();
  IntColumn get progressPercent => integer().nullable()();
  DateTimeColumn get targetHandoverAt => dateTime().nullable()();
  DateTimeColumn get forecastHandoverAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get sortCursor => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('MilestoneRow')
class Milestones extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get title => text()();
  TextColumn get state => text()();
  IntColumn get sortIndex => integer()();
  DateTimeColumn get plannedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProductRow')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get salesMode => text()();
  IntColumn get priceMinor => integer().nullable()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get specs => text()();
  TextColumn get imageHint => text()();
  BoolColumn get published => boolean().withDefault(const Constant(true))();
  TextColumn get sortCursor => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CartRow')
class Carts extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().nullable().references(Accounts, #id)();
  IntColumn get totalMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('CartItemRow')
class CartItems extends Table {
  TextColumn get id => text()();
  TextColumn get cartId => text().references(Carts, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get nameSnapshot => text()();
  IntColumn get unitPriceMinor => integer()();
  TextColumn get currency => text()();
  IntColumn get quantity => integer()();
  BoolColumn get unavailable => boolean().withDefault(const Constant(false))();
  BoolColumn get repriced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SiteUpdateRow')
class SiteUpdates extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  BoolColumn get published => boolean()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get eventAt => dateTime()();
  TextColumn get sortCursor => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AssetRow')
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get visualHint => text()();
  TextColumn get caption => text().nullable()();
  BoolColumn get published => boolean()();
  BoolColumn get withdrawn => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SiteUpdateAssetRow')
class SiteUpdateAssets extends Table {
  TextColumn get updateId => text().references(SiteUpdates, #id)();
  TextColumn get assetId => text().references(Assets, #id)();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {updateId, assetId};
}

@DataClassName('ProjectBalanceRow')
class ProjectBalances extends Table {
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get currency => text()();
  DateTimeColumn get asOf => dateTime()();
  IntColumn get totalContractMinor => integer()();
  IntColumn get approvedVariationsMinor => integer()();
  IntColumn get netReceivedMinor => integer()();
  IntColumn get outstandingTotalMinor => integer()();
  IntColumn get amountCurrentlyDueMinor => integer()();
  IntColumn get creditOverpaymentMinor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {projectId};
}

@DataClassName('LedgerEntryRow')
class LedgerEntries extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get description => text()();
  TextColumn get state => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get postedAt => dateTime()();
  TextColumn get sortCursor => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DueScheduleRow')
class DueScheduleItems extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get label => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get dueAt => dateTime()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProjectDocumentRow')
class ProjectDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get assetId => text().references(Assets, #id)();
  BoolColumn get published => boolean()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DesignRow')
class Designs extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().references(Projects, #id)();
  TextColumn get title => text()();
  TextColumn get versionLabel => text()();
  BoolColumn get approved => boolean()();
  BoolColumn get published => boolean()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DesignAssetRow')
class DesignAssets extends Table {
  TextColumn get designId => text().references(Designs, #id)();
  TextColumn get assetId => text().references(Assets, #id)();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {designId, assetId};
}

@DataClassName('SupportQueryRow')
class SupportQueries extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get projectId => text().nullable()();
  TextColumn get orderId => text().nullable()();
  TextColumn get subject => text()();
  TextColumn get message => text()();
  TextColumn get status => text()();
  TextColumn get queueLabel => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DeviceRow')
class Devices extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get platform => text()();
  TextColumn get installationId => text()();
  TextColumn get pushToken => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('NotificationRow')
class InAppNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get targetType => text()();
  TextColumn get targetId => text()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('DeliveryAddressRow')
class DeliveryAddresses extends Table {
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get fullName => text()();
  TextColumn get mobile => text()();
  TextColumn get line => text()();
  TextColumn get postcode => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {accountId};
}

@DataClassName('ShopOrderRow')
class ShopOrders extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get status => text()();
  TextColumn get fullName => text()();
  TextColumn get mobile => text()();
  TextColumn get addressLine => text()();
  TextColumn get postcode => text()();
  IntColumn get totalMinor => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ShopOrderItemRow')
class ShopOrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text().references(ShopOrders, #id)();
  TextColumn get productId => text()();
  TextColumn get nameSnapshot => text()();
  TextColumn get imageHint => text()();
  IntColumn get unitPriceMinor => integer()();
  TextColumn get currency => text()();
  IntColumn get quantity => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProductEnquiryRow')
class ProductEnquiries extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().nullable().references(Accounts, #id)();
  TextColumn get productId => text().nullable()();
  TextColumn get message => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AppMetaRow')
class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
