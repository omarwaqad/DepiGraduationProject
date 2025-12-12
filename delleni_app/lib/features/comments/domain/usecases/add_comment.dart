import 'package:delleni_app/features/comments/data/models/comment_model.dart';
import 'package:delleni_app/features/comments/domain/repositories/comments_repository.dart';

class AddComment {
  AddComment(this.repo);
  final CommentsRepository repo;

  Future<CommentModel> call(CommentModel comment) => repo.addComment(comment);
}
