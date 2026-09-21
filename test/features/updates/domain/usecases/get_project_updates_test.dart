import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/entities/page_result.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/updates/domain/entities/site_update.dart';
import 'package:rak_customer/features/updates/domain/repositories/updates_repository.dart';
import 'package:rak_customer/features/updates/domain/usecases/get_project_updates.dart';

class _MockUpdatesRepository extends Mock implements UpdatesRepository {}

void main() {
  late _MockUpdatesRepository repository;
  late GetProjectUpdates usecase;

  setUp(() {
    repository = _MockUpdatesRepository();
    usecase = GetProjectUpdates(repository);
  });

  test('passes the cursor through for pagination', () async {
    when(
      () => repository.getProjectUpdates(
        accountId: 'acc',
        projectId: 'prj',
        cursor: '009',
        pageSize: 2,
      ),
    ).thenAnswer(
      (_) async => const Success(PageResult(items: [], nextCursor: null)),
    );

    final result = await usecase(
      accountId: 'acc',
      projectId: 'prj',
      cursor: '009',
      pageSize: 2,
    );
    expect(result.isSuccess, isTrue);
    verify(
      () => repository.getProjectUpdates(
        accountId: 'acc',
        projectId: 'prj',
        cursor: '009',
        pageSize: 2,
      ),
    ).called(1);
  });

  test('keeps the repository order so the UI does not re-sort', () async {
    final page = PageResult(
      items: [
        SiteUpdate(
          id: 'newer',
          projectId: 'prj',
          published: true,
          note: 'Later',
          eventAt: DateTime.utc(2026, 9, 6),
          sortCursor: '009',
        ),
        SiteUpdate(
          id: 'older',
          projectId: 'prj',
          published: true,
          note: 'Earlier',
          eventAt: DateTime.utc(2026, 8, 12),
          sortCursor: '007',
        ),
      ],
      nextCursor: '007',
    );
    when(
      () => repository.getProjectUpdates(
        accountId: 'acc',
        projectId: 'prj',
        cursor: null,
        pageSize: 20,
      ),
    ).thenAnswer((_) async => Success(page));

    final result = await usecase(accountId: 'acc', projectId: 'prj');
    expect(result.valueOrNull?.items.map((u) => u.id), ['newer', 'older']);
  });
}
