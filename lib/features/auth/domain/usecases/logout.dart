import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class Logout {
  const Logout(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
