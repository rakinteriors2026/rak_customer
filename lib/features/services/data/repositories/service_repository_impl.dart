import 'package:rak_customer/core/domain/failures/failure.dart';
import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/services/data/datasources/service_local_datasource.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';
import 'package:rak_customer/features/services/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  ServiceRepositoryImpl(this._datasource);
  final ServiceLocalDatasource _datasource;

  @override
  Future<Result<List<InteriorService>>> getServices() async {
    try {
      return Success(_datasource.services());
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }

  @override
  Future<Result<InteriorService>> getService(String id) async {
    try {
      return Success(_datasource.service(id));
    } on Failure catch (failure) {
      return Err(failure);
    } catch (_) {
      return const Err(UnknownFailure());
    }
  }
}
