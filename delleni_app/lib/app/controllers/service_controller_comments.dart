part of 'service_controller.dart';

// Comment-related behaviors separated for clarity.
extension ServiceControllerComments on ServiceController {
  Future<void> fetchCommentsForSelectedService() async {
    final svc = selectedService.value;
    if (svc == null) return;

    try {
      isCommentsLoading.value = true;
      final list = await fetchCommentsForService(svc.id);
      comments.value = list;
    } catch (e) {
      // ignore: avoid_print
      print('fetchComments error: $e -- falling back to local comments if any');
      final fallback = localCommentFallback[svc.id] ?? [];
      comments.value = fallback;
    } finally {
      isCommentsLoading.value = false;
    }
  }

  /// Fetch all comments from all services (for society page)
  Future<List<CommentModel>> fetchAllComments() async {
    try {
      final serverComments = await fetchAllCommentsUseCase();
      final allLocalComments = localCommentFallback.values
          .expand((c) => c)
          .toList();

      final allComments = [...serverComments, ...allLocalComments];
      allComments.sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );

      return allComments;
    } catch (e) {
      // ignore: avoid_print
      print('fetchAllComments error: $e');
      return localCommentFallback.values.expand((c) => c).toList()..sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );
    }
  }

  /// Get logged-in username from users table
  Future<String?> getLoggedInUsername() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await supabase
          .from('users')
          .select('first_name, last_name')
          .eq('id', userId)
          .single();

      if (response != null) {
        final firstName = response['first_name'] ?? '';
        final lastName = response['last_name'] ?? '';
        return '$firstName $lastName'.trim();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching username: $e');
    }
    return null;
  }

  /// Post a comment, using logged-in user when available.
  Future<void> addComment(String content) async {
    final svc = selectedService.value;
    if (svc == null) return;

    String username = await getLoggedInUsername() ?? 'Anonymous';
    if (username.trim().isEmpty) {
      username = 'Anonymous';
    }

    final comment = CommentModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      serviceId: svc.id,
      username: username,
      content: content,
      likes: 0,
      createdAt: DateTime.now(),
    );

    comments.insert(0, comment);
    comments.refresh();

    try {
      final saved = await addCommentUseCase(comment);
      comments.remove(comment);
      comments.insert(0, saved);
      comments.refresh();
    } catch (e) {
      // ignore: avoid_print
      print('Failed to insert comment to server: $e');
      localCommentFallback.putIfAbsent(svc.id, () => []).insert(0, comment);
    }
  }

  /// Like a comment; user can only like or dislike once.
  Future<void> likeComment(CommentModel c) async {
    final currentReaction = userReactions[c.id];

    if (currentReaction == 'like') {
      c.likes--;
      userReactions[c.id] = null;
    } else if (currentReaction == 'dislike') {
      c.dislikes--;
      c.likes++;
      userReactions[c.id] = 'like';
    } else {
      c.likes++;
      userReactions[c.id] = 'like';
    }

    comments.refresh();

    try {
      await updateReactionUseCase(
        commentId: c.id,
        likes: c.likes,
        dislikes: c.dislikes,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Failed to update reaction on server: $e — keeping locally');
    }
  }

  /// Dislike a comment; user can only like or dislike once.
  Future<void> dislikeComment(CommentModel c) async {
    final currentReaction = userReactions[c.id];

    if (currentReaction == 'dislike') {
      c.dislikes--;
      userReactions[c.id] = null;
    } else if (currentReaction == 'like') {
      c.likes--;
      c.dislikes++;
      userReactions[c.id] = 'dislike';
    } else {
      c.dislikes++;
      userReactions[c.id] = 'dislike';
    }

    comments.refresh();

    try {
      await updateReactionUseCase(
        commentId: c.id,
        likes: c.likes,
        dislikes: c.dislikes,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Failed to update reaction on server: $e — keeping locally');
    }
  }

  bool hasLiked(String commentId) => userReactions[commentId] == 'like';

  bool hasDisliked(String commentId) => userReactions[commentId] == 'dislike';
}
