import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/documents/domain/entities/project_document.dart';
import 'package:rak_customer/features/documents/domain/usecases/get_project_documents.dart';

sealed class DocumentsState {
  const DocumentsState();
}

class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

class DocumentsEmpty extends DocumentsState {
  const DocumentsEmpty();
}

class DocumentsLoaded extends DocumentsState {
  DocumentsLoaded(this.documents) : typeOrder = _typeOrder(documents);

  final List<ProjectDocument> documents;
  final List<String> typeOrder;

  static List<String> _typeOrder(List<ProjectDocument> documents) {
    const preferred = ['agreement', 'quotation', 'invoice'];
    final present = documents.map((d) => d.type).toSet();
    return [
      ...preferred.where(present.contains),
      ...present.where((type) => !preferred.contains(type)),
    ];
  }
}

class DocumentsError extends DocumentsState {
  const DocumentsError(this.message);
  final String message;
}

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit({
    required GetProjectDocuments getProjectDocuments,
    required this.accountId,
    required this.projectId,
  }) : _getProjectDocuments = getProjectDocuments,
       super(const DocumentsLoading());

  final GetProjectDocuments _getProjectDocuments;
  final String accountId;
  final String projectId;

  Future<void> load() async {
    emit(const DocumentsLoading());
    final result = await _getProjectDocuments(
      accountId: accountId,
      projectId: projectId,
    );
    result.fold(
      onSuccess: (documents) {
        if (documents.isEmpty) {
          emit(const DocumentsEmpty());
          return;
        }
        emit(DocumentsLoaded(documents));
      },
      onFailure: (failure) => emit(DocumentsError(failure.message)),
    );
  }
}
