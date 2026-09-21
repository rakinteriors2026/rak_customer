import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/domain/repositories/design_repository.dart';
import 'package:rak_customer/features/designs/domain/usecases/get_approved_designs.dart';

class _MockDesignRepository extends Mock implements DesignRepository {}

void main() {
  late _MockDesignRepository repository;
  late GetApprovedDesigns usecase;

  setUp(() {
    repository = _MockDesignRepository();
    usecase = GetApprovedDesigns(repository);
  });

  test('returns approved published designs from the repository', () async {
    const designs = [
      ApprovedDesign(
        id: 'dsn_living',
        projectId: 'prj',
        title: 'Living room',
        versionLabel: 'Rev C',
        assetIds: ['ast_design_living'],
      ),
    ];
    when(
      () => repository.getDesigns(accountId: 'acc', projectId: 'prj'),
    ).thenAnswer((_) async => const Success(designs));

    final result = await usecase(accountId: 'acc', projectId: 'prj');
    expect(result.valueOrNull, designs);
  });

  test('surfaces not-found when the project is not owned', () async {
    when(
      () => repository.getDesigns(accountId: 'acc_buyer', projectId: 'prj'),
    ).thenAnswer((_) async => const Err(NotFoundFailure()));

    final result = await usecase(accountId: 'acc_buyer', projectId: 'prj');
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
