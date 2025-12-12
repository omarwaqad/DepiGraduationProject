import 'package:delleni_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginUseCase {
  LoginUseCase(this.repo);
  final AuthRepository repo;

  Future<AuthResponse> call({required String email, required String password}) {
    return repo.login(email: email, password: password);
  }
}
