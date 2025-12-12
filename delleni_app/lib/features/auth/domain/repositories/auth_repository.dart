import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({required String email, required String password});
  Future<void> logout();
  Future<AuthResponse> register({required String email, required String password, required Map<String, dynamic> profile});
}
