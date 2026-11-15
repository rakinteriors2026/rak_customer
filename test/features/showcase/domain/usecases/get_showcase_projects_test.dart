import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/showcase/domain/entities/showcase_project.dart';
import 'package:rak_customer/features/showcase/domain/repositories/showcase_repository.dart';
import 'package:rak_customer/features/showcase/domain/usecases/get_showcase_projects.dart';

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
  pieces: const [
    ShowcasePiece(
      name: 'Linen three-seat sofa',
      categoryLabel: 'Furniture',
      imageAsset: 'assets/showcase/piece_linen_sofa.jpg',
      productId: 'prod_linen_sofa',
    ),
  ],
);

void main() {
  late _MockShowcaseRepository repository;
  late GetShowcaseProjects usecase;

  setUp(() {
    repository = _MockShowcaseRepository();
    usecase = GetShowcaseProjects(repository);
  });

  test('returns the reference projects from the repository', () async {
    when(
      () => repository.getProjects(),
    ).thenAnswer((_) async => Success([_project('show_backwater')]));

    final result = await usecase();

    expect(result.valueOrNull, isNotNull);
    expect(result.valueOrNull!.single.id, 'show_backwater');
  });
}
