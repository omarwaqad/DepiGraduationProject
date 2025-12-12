import 'package:delleni_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this.repo);
  final AuthRepository repo;

  Future<void> call() => repo.logout();
}
