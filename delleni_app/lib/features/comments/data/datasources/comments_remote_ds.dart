import 'package:delleni_app/features/comments/data/models/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CommentsRemoteDataSource {
  Future<List<CommentModel>> fetchForService(String serviceId);
  Future<List<CommentModel>> fetchAll();
  Future<CommentModel> addComment(CommentModel comment);
  Future<void> updateReaction({required String commentId, required int likes, required int dislikes});
}

class CommentsRemoteDataSourceImpl implements CommentsRemoteDataSource {
  CommentsRemoteDataSourceImpl(this.client);

  final SupabaseClient client;

  @override
  Future<List<CommentModel>> fetchForService(String serviceId) async {
    final res = await client
        .from('comments')
        .select()
        .eq('service_id', serviceId)
        .order('created_at', ascending: true);

    return (res as List<dynamic>)
        .map((e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<CommentModel>> fetchAll() async {
    final res = await client
        .from('comments')
        .select()
        .order('created_at', ascending: false);

    return (res as List<dynamic>)
        .map((e) => CommentModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<CommentModel> addComment(CommentModel comment) async {
    final response = await client
        .from('comments')
        .insert(comment.toMapForInsert())
        .select()
        .single();

    return CommentModel.fromMap(Map<String, dynamic>.from(response));
  }

  @override
  Future<void> updateReaction({
    required String commentId,
    required int likes,
    required int dislikes,
  }) async {
    await client
        .from('comments')
        .update({'likes': likes, 'dislikes': dislikes})
        .eq('id', commentId);
  }
}
