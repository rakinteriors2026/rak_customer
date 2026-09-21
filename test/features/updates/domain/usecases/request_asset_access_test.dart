import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/updates/domain/entities/asset_access.dart';
import 'package:rak_customer/features/updates/domain/repositories/updates_repository.dart';
import 'package:rak_customer/features/updates/domain/usecases/request_asset_access.dart';

class _MockUpdatesRepository extends Mock implements UpdatesRepository {}

void main() {
  late _MockUpdatesRepository repository;
  late RequestAssetAccess usecase;

  setUp(() {
    repository = _MockUpdatesRepository();
    usecase = RequestAssetAccess(repository);
  });

  test('returns short-lived access from the repository', () async {
    final dated = AssetAccess(
      assetId: 'ast_1',
      signedUrl: 'local-asset://ast_1?t=1',
      expiresAt: DateTime.utc(2026, 9, 8, 6, 32),
      visualHint: 'joinery',
    );
    when(
      () => repository.requestAssetAccess('ast_1'),
    ).thenAnswer((_) async => Success(dated));

    final result = await usecase('ast_1');
    expect(result.valueOrNull?.signedUrl, dated.signedUrl);
    expect(
      result.valueOrNull?.isExpiredAt(DateTime.utc(2026, 9, 8, 6, 31)),
      isFalse,
    );
  });

  test('surfaces withdrawn assets as not found', () async {
    when(() => repository.requestAssetAccess('ast_gone')).thenAnswer(
      (_) async =>
          const Err(NotFoundFailure('This photo is no longer available.')),
    );

    final result = await usecase('ast_gone');
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
