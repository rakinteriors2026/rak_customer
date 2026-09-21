import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/catalogue/domain/entities/product_enquiry.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/submit_product_enquiry.dart';

class _MockEnquiryRepository extends Mock implements EnquiryRepository {}

void main() {
  late _MockEnquiryRepository repository;
  late SubmitProductEnquiry usecase;

  setUp(() {
    repository = _MockEnquiryRepository();
    usecase = SubmitProductEnquiry(repository);
  });

  test('rejects an empty message', () async {
    final result = await usecase(message: '   ', productId: 'prod_oak_table');
    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(
      () => repository.submitEnquiry(
        message: any(named: 'message'),
        productId: any(named: 'productId'),
        accountId: any(named: 'accountId'),
      ),
    );
  });

  test('submits the message and product id', () async {
    final enquiry = ProductEnquiry(
      id: 'enq_1',
      message: 'Need dimensions',
      createdAt: DateTime.utc(2026, 9, 8),
      productId: 'prod_oak_table',
    );
    when(
      () => repository.submitEnquiry(
        message: 'Need dimensions',
        productId: 'prod_oak_table',
        accountId: 'acc',
      ),
    ).thenAnswer((_) async => Success(enquiry));

    final result = await usecase(
      message: 'Need dimensions',
      productId: 'prod_oak_table',
      accountId: 'acc',
    );

    expect(result.valueOrNull?.id, 'enq_1');
    expect(result.valueOrNull?.productId, 'prod_oak_table');
  });
}
