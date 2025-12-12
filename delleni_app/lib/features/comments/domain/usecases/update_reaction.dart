import 'package:delleni_app/features/comments/domain/repositories/comments_repository.dart';

class UpdateReaction {
  UpdateReaction(this.repo);
  final CommentsRepository repo;

  Future<void> call({required String commentId, required int likes, required int dislikes}) {
    return repo.updateReaction(commentId: commentId, likes: likes, dislikes: dislikes);
  }
}
