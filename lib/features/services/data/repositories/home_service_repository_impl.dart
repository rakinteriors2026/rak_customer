import 'package:rak_customer/core/domain/entities/home_service_item.dart';
import 'package:rak_customer/core/domain/repositories/home_service_repository.dart';
import 'package:rak_customer/features/services/data/datasources/service_local_datasource.dart';

/// Bridges the services feature to the storefront home through the shared
/// [HomeServiceRepository] contract in core/domain.
class HomeServiceRepositoryImpl implements HomeServiceRepository {
  HomeServiceRepositoryImpl(this._datasource);

  final ServiceLocalDatasource _datasource;

  @override
  Future<List<HomeServiceItem>> featured() async {
    return [
      for (final service in _datasource.services())
        HomeServiceItem(
          id: service.id,
          name: service.name,
          tagline: service.tagline,
          heroAsset: service.heroAsset,
        ),
    ];
  }
}
