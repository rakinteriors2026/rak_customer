import 'package:rak_customer/core/domain/result.dart';
import 'package:rak_customer/features/services/domain/entities/interior_service.dart';

abstract class ServiceRepository {
  Future<Result<List<InteriorService>>> getServices();
  Future<Result<InteriorService>> getService(String id);
}
