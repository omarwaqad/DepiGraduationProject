import 'package:delleni_app/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:delleni_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remote);
  final AuthRemoteDataSource remote;

  @override
  Future<AuthResponse> login({required String email, required String password}) {
    return remote.login(email: email, password: password);
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required Map<String, dynamic> profile,
  }) {
    return remote.register(email: email, password: password, profile: profile);
  }
}
