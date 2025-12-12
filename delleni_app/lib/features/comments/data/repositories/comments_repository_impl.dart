import 'package:delleni_app/features/comments/data/datasources/comments_remote_ds.dart';
import 'package:delleni_app/features/comments/data/models/comment_model.dart';
import 'package:delleni_app/features/comments/domain/repositories/comments_repository.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  CommentsRepositoryImpl(this.remoteDataSource);

  final CommentsRemoteDataSource remoteDataSource;

  @override
  Future<CommentModel> addComment(CommentModel comment) {
    return remoteDataSource.addComment(comment);
  }

  @override
  Future<List<CommentModel>> fetchAll() {
    return remoteDataSource.fetchAll();
  }

  @override
  Future<List<CommentModel>> fetchForService(String serviceId) {
    return remoteDataSource.fetchForService(serviceId);
  }

  @override
  Future<void> updateReaction({
    required String commentId,
    required int likes,
    required int dislikes,
  }) {
    return remoteDataSource.updateReaction(
      commentId: commentId,
      likes: likes,
      dislikes: dislikes,
    );
  }
}
