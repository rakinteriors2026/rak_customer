import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/features/catalogue/data/datasources/enquiry_local_datasource.dart';
import 'package:rak_customer/features/catalogue/data/repositories/enquiry_repository_impl.dart';

import '../../../helpers/memory_database.dart';

void main() {
  late AppDatabase db;
  late EnquiryRepositoryImpl repository;

  setUp(() async {
    db = createMemoryDatabase();
    await db.seedIfNeeded();
    repository = EnquiryRepositoryImpl(
      EnquiryLocalDatasource(
        db: db,
        clock: Clock(now: () => DateTime.utc(2026, 9, 8, 6, 30)),
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('stores the enquiry message and product id', () async {
    final result = await repository.submitEnquiry(
      message: 'Please quote a 3m oak table.',
      productId: 'prod_oak_table',
    );
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull?.message, 'Please quote a 3m oak table.');
    expect(result.valueOrNull?.productId, 'prod_oak_table');
    expect(result.valueOrNull?.status, 'submitted');

    final updated = await repository.updateStatus(
      enquiryId: result.valueOrNull!.id,
      status: 'contacted',
    );
    expect(updated.valueOrNull?.statusLabel, 'Consultant contacted');
    expect(updated.valueOrNull?.consultantNote, isNotNull);
  });

  test('rejects an empty enquiry', () async {
    final result = await repository.submitEnquiry(message: '  ');
    expect(result.failureOrNull, isA<ValidationFailure>());
  });

  test('rejects an unknown product', () async {
    final result = await repository.submitEnquiry(
      message: 'Need a quote',
      productId: 'prod_missing',
    );
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
