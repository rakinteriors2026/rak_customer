import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/repositories/service_repository.dart';

class GetServices {
  const GetServices(this._repository);
  final ServiceRepository _repository;

  Future<Result<List<InteriorService>>> call() => _repository.getServices();
}
