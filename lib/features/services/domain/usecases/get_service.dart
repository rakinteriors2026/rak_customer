import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/repositories/service_repository.dart';

class GetService {
  const GetService(this._repository);
  final ServiceRepository _repository;

  Future<Result<InteriorService>> call(String id) {
    if (id.isEmpty) {
      return Future.value(
        const Err(ValidationFailure('Missing service id.')),
      );
    }
    return _repository.getService(id);
  }
}
