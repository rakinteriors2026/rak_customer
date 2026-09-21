import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';
import 'package:rak_customer/features/documents/domain/repositories/document_repository.dart';
import 'package:rak_customer/features/documents/domain/usecases/get_project_documents.dart';

class _MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late _MockDocumentRepository repository;
  late GetProjectDocuments usecase;

  setUp(() {
    repository = _MockDocumentRepository();
    usecase = GetProjectDocuments(repository);
  });

  test('returns published documents from the repository', () async {
    final docs = [
      ProjectDocument(
        id: 'doc_1',
        projectId: 'prj',
        type: 'agreement',
        title: 'Agreement',
        assetId: 'ast_1',
        createdAt: DateTime.utc(2026, 3, 9),
      ),
    ];
    when(
      () => repository.getDocuments(accountId: 'acc', projectId: 'prj'),
    ).thenAnswer((_) async => Success(docs));

    final result = await usecase(accountId: 'acc', projectId: 'prj');
    expect(result.valueOrNull, docs);
  });

  test('surfaces not-found when the project is not owned', () async {
    when(
      () => repository.getDocuments(accountId: 'acc_buyer', projectId: 'prj'),
    ).thenAnswer((_) async => const Err(NotFoundFailure()));

    final result = await usecase(accountId: 'acc_buyer', projectId: 'prj');
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });
}
