import 'package:delleni_app/app/data/models/user_model.dart' as models;
import 'package:delleni_app/app/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  SupabaseClient get _supabase => SupabaseService.instance;

  /// Login user
  Future<models.User?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) return null;

      // Get user profile
      return await getUserProfile(response.user!.id);
    } catch (e) {
      return null;
    }
  }

  /// Register new user
  Future<models.User?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String address,
    required String password,
  }) async {
    try {
      // 1. Create auth user
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) return null;

      final userId = authResponse.user!.id;

      // 2. Create user profile
      await _supabase.from('users').insert({
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'address': address,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 3. Return user with profile
      return await getUserProfile(userId);
    } catch (e) {
      return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  /// Get current user with profile
  Future<models.User?> getCurrentUser() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null) return null;

    return await getUserProfile(currentUser.id);
  }

  /// Get user profile by ID
  Future<models.User?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return models.User.fromMap(response);
    } catch (e) {
      // Return basic user info if profile not found
      final authUser = _supabase.auth.currentUser;
      if (authUser?.id == userId) {
        return models.User(id: userId, email: authUser!.email ?? '');
      }
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
