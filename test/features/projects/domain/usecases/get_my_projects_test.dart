import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/repositories/project_repository.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_my_projects.dart';

class _MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late _MockProjectRepository repository;
  late GetMyProjects usecase;

  setUp(() {
    repository = _MockProjectRepository();
    usecase = GetMyProjects(repository);
  });

  test('returns an empty page for a buyer-only account', () async {
    when(
      () => repository.getMyProjects(accountId: 'acc_buyer', cursor: null),
    ).thenAnswer((_) async => const Success(PageResult(items: [])));

    final result = await usecase(accountId: 'acc_buyer');
    expect(result.valueOrNull?.isEmpty, isTrue);
  });

  test('returns every authorised project without reshuffling', () async {
    final projects = [
      InteriorProject(
        id: 'a',
        name: 'One',
        siteLabel: 'Kochi',
        phaseCode: 'FITOUT',
        phaseLabel: 'Fit-out',
        progressPercent: 62,
        targetHandoverAt: DateTime.utc(2026, 12, 15),
        forecastHandoverAt: DateTime.utc(2027, 1, 20),
        updatedAt: DateTime.utc(2026, 9, 8),
      ),
      InteriorProject(
        id: 'b',
        name: 'Two',
        siteLabel: 'Bengaluru',
        phaseCode: 'DESIGN_DEV',
        phaseLabel: 'Design development',
        progressPercent: null,
        targetHandoverAt: DateTime.utc(2026, 11, 1),
        forecastHandoverAt: null,
        updatedAt: DateTime.utc(2026, 9, 6),
      ),
    ];
    when(
      () => repository.getMyProjects(accountId: 'acc_projects', cursor: null),
    ).thenAnswer((_) async => Success(PageResult(items: projects)));

    final result = await usecase(accountId: 'acc_projects');
    expect(result.valueOrNull?.items.map((p) => p.id), ['a', 'b']);
    expect(result.valueOrNull?.items.last.progressPercent, isNull);
  });
}
