import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login({required String email, required String password});
  Future<void> logout();
  Future<AuthResponse> register({
    required String email,
    required String password,
    required Map<String, dynamic> profile,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.client);
  final SupabaseClient client;

  @override
  Future<AuthResponse> login({required String email, required String password}) {
    return client.auth.signInWithPassword(email: email.trim(), password: password.trim());
  }

  @override
  Future<void> logout() {
    return client.auth.signOut();
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required Map<String, dynamic> profile,
  }) async {
    final res = await client.auth.signUp(email: email.trim(), password: password.trim());
    final user = res.user;
    if (user != null) {
      await client.from('users').insert({...profile, 'id': user.id});
    }
    return res;
  }
}
