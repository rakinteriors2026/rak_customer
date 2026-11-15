import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/usecases/get_service.dart';

sealed class ServiceDetailState {
  const ServiceDetailState();
}

class ServiceDetailLoading extends ServiceDetailState {
  const ServiceDetailLoading();
}

class ServiceDetailLoaded extends ServiceDetailState {
  const ServiceDetailLoaded(this.service);
  final InteriorService service;
}

class ServiceDetailError extends ServiceDetailState {
  const ServiceDetailError(this.message);
  final String message;
}

class ServiceDetailCubit extends Cubit<ServiceDetailState> {
  ServiceDetailCubit({required GetService getService})
    : _getService = getService,
      super(const ServiceDetailLoading());

  final GetService _getService;

  Future<void> load(String id) async {
    emit(const ServiceDetailLoading());
    final result = await _getService(id);
    emit(
      result.fold(
        onSuccess: ServiceDetailLoaded.new,
        onFailure: (failure) => ServiceDetailError(failure.message),
      ),
    );
  }
}
