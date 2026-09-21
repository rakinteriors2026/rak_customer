import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/theme/app_spacing.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';
import 'package:rak_customer/features/documents/domain/usecases/get_project_documents.dart';
import 'package:rak_customer/features/documents/presentation/cubit/documents_cubit.dart';
import 'package:rak_customer/features/documents/presentation/pages/document_viewer_page.dart';
import 'package:rak_customer/shared/formatters/date_formatter.dart';
import 'package:rak_customer/shared/widgets/app_empty_state.dart';
import 'package:rak_customer/shared/widgets/app_error_state.dart';

class ProjectDocumentsSection extends StatelessWidget {
  const ProjectDocumentsSection({
    super.key,
    required this.accountId,
    required this.projectId,
    this.showHeading = true,
  });

  final String accountId;
  final String projectId;
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentsCubit(
        getProjectDocuments: sl<GetProjectDocuments>(),
        accountId: accountId,
        projectId: projectId,
      )..load(),
      child: _DocumentsBody(showHeading: showHeading),
    );
  }
}

class _DocumentsBody extends StatelessWidget {
  const _DocumentsBody({required this.showHeading});
  final bool showHeading;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeading) ...[
              Text('Documents', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
            ],
            switch (state) {
              DocumentsLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              DocumentsEmpty() => const AppEmptyState(
                title: 'No documents yet',
                message:
                    'Published agreements, quotations, and invoices will appear here.',
                icon: Icons.description_outlined,
              ),
              DocumentsError(:final message) => AppErrorState(
                message: message,
                onRetry: () => context.read<DocumentsCubit>().load(),
              ),
              DocumentsLoaded(:final documents, :final typeOrder) =>
                DocumentsGroupedList(
                  documents: documents,
                  typeOrder: typeOrder,
                ),
            },
          ],
        );
      },
    );
  }
}

class DocumentsGroupedList extends StatelessWidget {
  const DocumentsGroupedList({
    super.key,
    required this.documents,
    this.typeOrder = const ['agreement', 'quotation', 'invoice'],
    this.onOpen,
  });

  final List<ProjectDocument> documents;
  final List<String> typeOrder;
  final void Function(ProjectDocument document)? onOpen;

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return const AppEmptyState(
        title: 'No documents yet',
        message:
            'Published agreements, quotations, and invoices will appear here.',
        icon: Icons.description_outlined,
      );
    }
    final present = documents.map((d) => d.type).toSet();
    final groups = [
      ...typeOrder.where(present.contains),
      ...present.where((type) => !typeOrder.contains(type)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final type in groups) ...[
          Text(_labelFor(type), style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          ...documents
              .where((d) => d.type == type)
              .map(
                (doc) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: Text(doc.title),
                  subtitle: Text(DateFormatter.displayDate(doc.createdAt)),
                  onTap: () {
                    if (onOpen != null) {
                      onOpen!(doc);
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DocumentViewerPage(
                          assetId: doc.assetId,
                          title: doc.title,
                        ),
                      ),
                    );
                  },
                ),
              ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }

  String _labelFor(String type) => switch (type) {
    'agreement' => 'Agreements',
    'quotation' => 'Quotations',
    'invoice' => 'Invoices',
    _ => type,
  };
}
