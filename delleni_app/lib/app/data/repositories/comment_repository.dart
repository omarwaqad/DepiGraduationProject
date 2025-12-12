import 'package:delleni_app/app/data/models/comment_model.dart';
import 'package:delleni_app/app/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepository {
  SupabaseClient get _supabase => SupabaseService.instance;

  /// Get comments for a specific service
  Future<List<CommentModel>> getCommentsByService(String serviceId) async {
    try {
      final response = await _supabase
          .from('comments')
          .select()
          .eq('service_id', serviceId)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((e) => CommentModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all comments (for society page)
  Future<List<CommentModel>> getAllComments() async {
    try {
      final response = await _supabase
          .from('comments')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((e) => CommentModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new comment
  Future<CommentModel?> addComment({
    required String serviceId,
    required String username,
    required String content,
  }) async {
    try {
      final newComment = {
        'service_id': serviceId,
        'username': username,
        'content': content,
        'likes': 0,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('comments')
          .insert(newComment)
          .select()
          .single();

      return CommentModel.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  /// Like a comment
  Future<bool> likeComment(String commentId, int currentLikes) async {
    try {
      await _supabase
          .from('comments')
          .update({'likes': currentLikes + 1})
          .eq('id', commentId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get comment count for a service
  Future<int> getCommentCount(String serviceId) async {
    try {
      // request the count from Supabase/PostgREST
      final res = await _supabase
          .from('comments')
          .select(
            'id',
          ) // select whatever column; the count will be returned separately
          .eq('service_id', serviceId)
          .count(CountOption.exact);

      // res is a PostgrestResponse-like object: read the count field
      final int? count = res.count as int?;
      return count ?? 0;
    } catch (e) {
      print('getCommentCount error: $e');
      return 0;
    }
  }
}
