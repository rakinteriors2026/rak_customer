import 'package:rak_customer/core/domain/entities/session.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/result.dart';

class GetCurrentSession {
  const GetCurrentSession(this._repository);
  final AuthRepository _repository;

  Future<Result<Session?>> call() => _repository.currentSession();
}
