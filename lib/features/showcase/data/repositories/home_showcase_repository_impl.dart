import 'package:rak_customer/core/domain/entities/home_showcase_item.dart';
import 'package:rak_customer/core/domain/repositories/home_showcase_repository.dart';
import 'package:rak_customer/features/showcase/data/datasources/showcase_local_datasource.dart';

/// Bridges the showcase feature to the storefront home through the shared
/// [HomeShowcaseRepository] contract in core/domain.
class HomeShowcaseRepositoryImpl implements HomeShowcaseRepository {
  HomeShowcaseRepositoryImpl(this._datasource);

  final ShowcaseLocalDatasource _datasource;

  @override
  Future<List<HomeShowcaseItem>> featured() async {
    return [
      for (final project in _datasource.projects())
        HomeShowcaseItem(
          id: project.id,
          title: project.title,
          styleLabel: project.styleLabel,
          locationLabel: project.locationLabel,
          coverAsset: project.coverAsset,
        ),
    ];
  }
}
