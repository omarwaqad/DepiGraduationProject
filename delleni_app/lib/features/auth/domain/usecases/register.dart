import 'package:delleni_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterUseCase {
  RegisterUseCase(this.repo);
  final AuthRepository repo;

  Future<AuthResponse> call({
    required String email,
    required String password,
    required Map<String, dynamic> profile,
  }) {
    return repo.register(email: email, password: password, profile: profile);
  }
}
