import 'package:delleni_app/app/data/models/user_model.dart' as models;
import 'package:delleni_app/app/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  SupabaseClient get _supabase => SupabaseService.instance;

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
      return null;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (phoneNumber != null) updates['phone_number'] = phoneNumber;
      if (address != null) updates['address'] = address;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from('users').update(updates).eq('id', userId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      // Get user contributions (comments count)
      final commentsResponse = await _supabase
          .from('comments')
          .select('id')
          .eq('username', userId); // Assuming username is userId or user email

      final contributionsCount = commentsResponse.length;

      // Get user favorites count
      final favoritesResponse = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', userId);

      final favoritesCount = favoritesResponse.length;

      return {
        'contributions': contributionsCount,
        'favorites': favoritesCount,
        'completed': 0, // You can calculate this from progress
        'active': 0, // You can calculate this from progress
      };
    } catch (e) {
      return {'contributions': 0, 'favorites': 0, 'completed': 0, 'active': 0};
    }
  }

  /// Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
