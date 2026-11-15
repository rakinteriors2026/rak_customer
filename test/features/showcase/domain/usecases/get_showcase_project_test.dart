import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/repositories/showcase_repository.dart';
import 'package:rak_customer/features/showcase/domain/usecases/get_showcase_project.dart';

class _MockShowcaseRepository extends Mock implements ShowcaseRepository {}

ShowcaseProject _project(String id) => ShowcaseProject(
  id: id,
  title: 'Backwater Villa',
  styleLabel: 'Warm contemporary',
  locationLabel: 'Kumarakom, Kerala',
  homeType: '4 BHK villa',
  summary: 'A warm, grounded home.',
  story: 'Oak runs through the living spaces.',
  scopeLabel: 'Living, kitchen and bedrooms',
  coverAsset: 'assets/showcase/showcase_backwater_cover.jpg',
  gallery: const [
    ShowcaseImage(asset: 'assets/showcase/showcase_backwater_cover.jpg'),
  ],
  pieces: const [],
);

void main() {
  late _MockShowcaseRepository repository;
  late GetShowcaseProject usecase;

  setUp(() {
    repository = _MockShowcaseRepository();
    usecase = GetShowcaseProject(repository);
  });

  test('validates an empty id before touching the repository', () async {
    final result = await usecase('');

    expect(result.failureOrNull, isA<ValidationFailure>());
    verifyNever(() => repository.getProject(any()));
  });

  test('returns the project for a known id', () async {
    when(
      () => repository.getProject('show_backwater'),
    ).thenAnswer((_) async => Success(_project('show_backwater')));

    final result = await usecase('show_backwater');

    expect(result.valueOrNull?.id, 'show_backwater');
  });

  test('surfaces not-found for an unknown id', () async {
    when(
      () => repository.getProject('nope'),
    ).thenAnswer((_) async => const Err(NotFoundFailure()));

    final result = await usecase('nope');

    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
