import 'package:drift/drift.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';

class EnquiryLocalDatasource {
  EnquiryLocalDatasource({required AppDatabase db, required Clock clock})
    : _db = db,
      _clock = clock;

  final AppDatabase _db;
  final Clock _clock;

  Future<ProductEnquiry> submit({
    required String message,
    String? productId,
    String? accountId,
  }) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Tell us about the piece and your space.');
    }

    final resolvedProductId = productId?.trim();
    if (resolvedProductId != null && resolvedProductId.isNotEmpty) {
      final product =
          await (_db.select(_db.products)..where(
                (t) =>
                    t.id.equals(resolvedProductId) & t.published.equals(true),
              ))
              .getSingleOrNull();
      if (product == null) {
        throw const NotFoundFailure('This product is not available.');
      }
    }

    final resolvedAccountId = accountId?.trim();
    if (resolvedAccountId != null && resolvedAccountId.isNotEmpty) {
      final account = await (_db.select(
        _db.accounts,
      )..where((t) => t.id.equals(resolvedAccountId))).getSingleOrNull();
      if (account == null) {
        throw const NotFoundFailure(
          'Please sign in again to send this enquiry.',
        );
      }
    }

    final now = _clock.now().toUtc();
    final id = 'enq_${now.microsecondsSinceEpoch}';
    final hasProduct =
        resolvedProductId != null && resolvedProductId.isNotEmpty;
    final hasAccount =
        resolvedAccountId != null && resolvedAccountId.isNotEmpty;
    await _db
        .into(_db.productEnquiries)
        .insert(
          ProductEnquiriesCompanion.insert(
            id: id,
            accountId: Value(hasAccount ? resolvedAccountId : null),
            productId: Value(hasProduct ? resolvedProductId : null),
            message: trimmed,
            createdAt: now,
          ),
        );

    await _writeStatus(id, 'submitted');
    return ProductEnquiry(
      id: id,
      message: trimmed,
      createdAt: now,
      accountId: hasAccount ? resolvedAccountId : null,
      productId: hasProduct ? resolvedProductId : null,
    );
  }

  Future<ProductEnquiry> getById(String enquiryId) async {
    final row = await (_db.select(
      _db.productEnquiries,
    )..where((t) => t.id.equals(enquiryId))).getSingleOrNull();
    if (row == null) {
      throw const NotFoundFailure('This enquiry is not available.');
    }
    return _toEnquiry(row, await _readStatus(row.id));
  }

  Future<List<ProductEnquiry>> list({String? accountId}) async {
    final query = _db.select(_db.productEnquiries)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    if (accountId != null && accountId.isNotEmpty) {
      query.where((t) => t.accountId.equals(accountId));
    }
    final rows = await query.get();
    final enquiries = <ProductEnquiry>[];
    for (final row in rows) {
      enquiries.add(_toEnquiry(row, await _readStatus(row.id)));
    }
    return enquiries;
  }

  Future<ProductEnquiry> updateStatus({
    required String enquiryId,
    required String status,
  }) async {
    if (!ProductEnquiry.knownStatuses.contains(status)) {
      throw const ValidationFailure('That enquiry status is not available.');
    }
    await getById(enquiryId);
    await _writeStatus(enquiryId, status);
    return getById(enquiryId);
  }

  Future<void> _writeStatus(String enquiryId, String status) {
    return _db.into(_db.appMeta).insertOnConflictUpdate(
      AppMetaCompanion.insert(key: 'enquiry_status_$enquiryId', value: status),
    );
  }

  Future<String> _readStatus(String enquiryId) async {
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals('enquiry_status_$enquiryId'))).getSingleOrNull();
    return row?.value ?? 'submitted';
  }

  ProductEnquiry _toEnquiry(ProductEnquiryRow row, String status) {
    return ProductEnquiry(
      id: row.id,
      message: row.message,
      createdAt: row.createdAt,
      accountId: row.accountId,
      productId: row.productId,
      status: status,
    );
  }
}
