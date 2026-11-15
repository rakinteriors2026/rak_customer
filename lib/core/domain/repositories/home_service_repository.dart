import 'package:rak_customer/core/domain/entities/home_service_item.dart';

/// Shared contract so the storefront home can show RAK services without
/// importing the services feature. Implemented in the services feature's
/// data layer, mirroring [HomeShowcaseRepository].
abstract class HomeServiceRepository {
  Future<List<HomeServiceItem>> featured();
}
