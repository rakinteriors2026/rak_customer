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

    return ProductEnquiry(
      id: id,
      message: trimmed,
      createdAt: now,
      accountId: hasAccount ? resolvedAccountId : null,
      productId: hasProduct ? resolvedProductId : null,
    );
  }
}
