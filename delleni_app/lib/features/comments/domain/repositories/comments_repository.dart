import 'package:delleni_app/features/comments/data/models/comment_model.dart';

abstract class CommentsRepository {
  Future<List<CommentModel>> fetchForService(String serviceId);
  Future<List<CommentModel>> fetchAll();
  Future<CommentModel> addComment(CommentModel comment);
  Future<void> updateReaction({required String commentId, required int likes, required int dislikes});
}
