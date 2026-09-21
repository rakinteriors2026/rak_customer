import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/designs/domain/entities/approved_design.dart';
import 'package:rak_customer/features/designs/domain/usecases/get_approved_designs.dart';

sealed class DesignsState {
  const DesignsState();
}

class DesignsLoading extends DesignsState {
  const DesignsLoading();
}

class DesignsEmpty extends DesignsState {
  const DesignsEmpty();
}

class DesignsLoaded extends DesignsState {
  const DesignsLoaded(this.designs);
  final List<ApprovedDesign> designs;
}

class DesignsError extends DesignsState {
  const DesignsError(this.message);
  final String message;
}

class DesignsCubit extends Cubit<DesignsState> {
  DesignsCubit({
    required GetApprovedDesigns getApprovedDesigns,
    required this.accountId,
    required this.projectId,
  }) : _getApprovedDesigns = getApprovedDesigns,
       super(const DesignsLoading());

  final GetApprovedDesigns _getApprovedDesigns;
  final String accountId;
  final String projectId;

  Future<void> load() async {
    emit(const DesignsLoading());
    final result = await _getApprovedDesigns(
      accountId: accountId,
      projectId: projectId,
    );
    result.fold(
      onSuccess: (designs) {
        if (designs.isEmpty) {
          emit(const DesignsEmpty());
          return;
        }
        emit(DesignsLoaded(designs));
      },
      onFailure: (failure) => emit(DesignsError(failure.message)),
    );
  }
}
