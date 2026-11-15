import 'package:rak_customer/core/domain/entities/home_showcase_item.dart';

/// Shared contract so the storefront home can show finished RAK interiors
/// without importing the showcase feature. Implemented in the showcase
/// feature's data layer, mirroring [HomeProjectRepository].
abstract class HomeShowcaseRepository {
  Future<List<HomeShowcaseItem>> featured();
}
