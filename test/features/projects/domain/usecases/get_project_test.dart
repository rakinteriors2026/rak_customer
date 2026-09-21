import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/projects/domain/entities/interior_project.dart';
import 'package:rak_customer/features/projects/domain/repositories/project_repository.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_project.dart';

class _MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late _MockProjectRepository repository;
  late GetProject usecase;

  setUp(() {
    repository = _MockProjectRepository();
    usecase = GetProject(repository);
  });

  test(
    'surfaces not-found when the project is not owned by the caller',
    () async {
      when(
        () => repository.getProject(
          accountId: 'acc_buyer',
          projectId: 'prj_albarari',
        ),
      ).thenAnswer(
        (_) async =>
            const Err(NotFoundFailure('This project is not available.')),
      );

      final result = await usecase(
        accountId: 'acc_buyer',
        projectId: 'prj_albarari',
      );
      expect(result.failureOrNull, isA<NotFoundFailure>());
    },
  );

  test('does not invent progress when the repository returns null', () async {
    final project = InteriorProject(
      id: 'prj_difc',
      name: 'HSR Layout apartment',
      siteLabel: 'HSR Layout, Bengaluru',
      phaseCode: 'DESIGN_DEV',
      phaseLabel: 'Design development',
      progressPercent: null,
      targetHandoverAt: DateTime.utc(2026, 11, 1),
      forecastHandoverAt: null,
      updatedAt: DateTime.utc(2026, 9, 6),
    );
    when(
      () => repository.getProject(
        accountId: 'acc_projects',
        projectId: 'prj_difc',
      ),
    ).thenAnswer((_) async => Success(project));

    final result = await usecase(
      accountId: 'acc_projects',
      projectId: 'prj_difc',
    );
    expect(result.valueOrNull?.progressPercent, isNull);
  });
}
