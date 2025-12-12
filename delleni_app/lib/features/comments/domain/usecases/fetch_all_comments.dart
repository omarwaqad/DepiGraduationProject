import 'package:delleni_app/features/comments/data/models/comment_model.dart';
import 'package:delleni_app/features/comments/domain/repositories/comments_repository.dart';

class FetchAllComments {
  FetchAllComments(this.repo);
  final CommentsRepository repo;

  Future<List<CommentModel>> call() => repo.fetchAll();
}
