import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/repositories/service_repository.dart';
import 'package:rak_customer/features/services/domain/usecases/get_service.dart';

class _MockServiceRepository extends Mock implements ServiceRepository {}

InteriorService _service(String id) => InteriorService(
  id: id,
  name: 'Modular Kitchens',
  tagline: 'Cook, store and gather',
  heroAsset: 'assets/services/svc_kitchen.jpg',
  summary: 'Hard-working modular kitchens.',
  description: 'Kitchens that store more and work harder.',
  durationLabel: '4–6 weeks',
  startingPriceLabel: 'From ₹1.5L',
  highlights: const ['Custom layout'],
  steps: const [
    ServiceStep(title: 'Layout', detail: 'We plan the work triangle.'),
  ],
);

void main() {
  late _MockServiceRepository repository;
  late GetService usecase;

  setUp(() {
    repository = _MockServiceRepository();
    usecase = GetService(repository);
  });

  test('validates an empty id before touching the repository', () async {
    final result = await usecase('');

    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(() => repository.getService(any()));
  });

  test('returns the service for a known id', () async {
    when(
      () => repository.getService('svc_kitchen'),
    ).thenAnswer((_) async => Success(_service('svc_kitchen')));

    final result = await usecase('svc_kitchen');

    expect(result.valueOrNull?.id, 'svc_kitchen');
  });

  test('surfaces not-found for an unknown id', () async {
    when(
      () => repository.getService('nope'),
    ).thenAnswer((_) async => const Err(NotFoundFailure()));

    final result = await usecase('nope');

    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
