import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/repositories/service_repository.dart';
import 'package:rak_customer/features/services/domain/usecases/get_services.dart';

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
  late GetServices usecase;

  setUp(() {
    repository = _MockServiceRepository();
    usecase = GetServices(repository);
  });

  test('returns the services from the repository', () async {
    when(
      () => repository.getServices(),
    ).thenAnswer((_) async => Success([_service('svc_kitchen')]));

    final result = await usecase();

    expect(result.valueOrNull, isNotNull);
    expect(result.valueOrNull!.single.id, 'svc_kitchen');
  });
}
