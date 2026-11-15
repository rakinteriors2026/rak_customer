import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/usecases/get_services.dart';

sealed class ServiceListState {
  const ServiceListState();
}

class ServiceListLoading extends ServiceListState {
  const ServiceListLoading();
}

class ServiceListLoaded extends ServiceListState {
  const ServiceListLoaded(this.services);
  final List<InteriorService> services;
}

class ServiceListError extends ServiceListState {
  const ServiceListError(this.message);
  final String message;
}

class ServiceListCubit extends Cubit<ServiceListState> {
  ServiceListCubit({required GetServices getServices})
    : _getServices = getServices,
      super(const ServiceListLoading());

  final GetServices _getServices;

  Future<void> load() async {
    emit(const ServiceListLoading());
    final result = await _getServices();
    emit(
      result.fold(
        onSuccess: ServiceListLoaded.new,
        onFailure: (failure) => ServiceListError(failure.message),
      ),
    );
  }
}
