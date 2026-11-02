import 'package:rak_customer/core/domain/entities/home_project_progress.dart';

abstract class HomeProjectRepository {
  Future<List<HomeProjectProgress>> progressFor(String accountId);
}
