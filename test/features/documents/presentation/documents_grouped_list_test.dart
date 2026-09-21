import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';
import 'package:rak_customer/features/documents/presentation/widgets/project_documents_section.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';

void main() {
  testWidgets('groups published documents by type', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: DocumentsGroupedList(
            documents: [
              ProjectDocument(
                id: 'doc_invoice',
                projectId: 'prj',
                type: 'invoice',
                title: 'Progress invoice 1',
                assetId: 'ast_doc_invoice',
                createdAt: DateTime.utc(2026, 6, 20),
              ),
              ProjectDocument(
                id: 'doc_agreement',
                projectId: 'prj',
                type: 'agreement',
                title: 'Interior works agreement',
                assetId: 'ast_doc_agreement',
                createdAt: DateTime.utc(2026, 3, 9),
              ),
            ],
            onOpen: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Agreements'), findsOneWidget);
    expect(find.text('Invoices'), findsOneWidget);
    expect(find.text('Interior works agreement'), findsOneWidget);
    expect(find.text('Progress invoice 1'), findsOneWidget);
  });

  testWidgets('empty documents is not an error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: DocumentsGroupedList(documents: [])),
      ),
    );

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('No documents yet'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });
}
