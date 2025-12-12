import 'package:get/get.dart';
import 'package:delleni_app/app/data/models/comment_model.dart';
import 'package:delleni_app/app/data/repositories/comment_repository.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';

class CommentsController extends GetxController {
  final CommentRepository _commentRepository = CommentRepository();
  final ServiceController _serviceController = Get.find<ServiceController>();

  // Comments for current service
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;

  // New comment text
  final RxString newCommentText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadComments();
  }

  /// Load comments for current service
  Future<void> loadComments() async {
    final service = _serviceController.selectedService.value;
    if (service == null) return;

    isLoading.value = true;
    try {
      final fetchedComments = await _commentRepository.getCommentsByService(
        service.id,
      );
      comments.assignAll(fetchedComments);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل التعليقات');
    } finally {
      isLoading.value = false;
    }
  }

  /// Add a new comment
  Future<void> addComment() async {
    final service = _serviceController.selectedService.value;
    if (service == null || newCommentText.value.trim().isEmpty) return;

    final content = newCommentText.value.trim();

    try {
      final newComment = await _commentRepository.addComment(
        serviceId: service.id,
        username: 'المستخدم الحالي', // Get from auth
        content: content,
      );

      if (newComment != null) {
        comments.insert(0, newComment);
        newCommentText.value = '';
        Get.snackbar('نجاح', 'تم إضافة التعليق');
      } else {
        Get.snackbar('خطأ', 'فشل إضافة التعليق');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إضافة التعليق');
    }
  }

  /// Like a comment
  Future<void> likeComment(CommentModel comment) async {
    try {
      final success = await _commentRepository.likeComment(
        comment.id,
        comment.likes,
      );

      if (success) {
        final index = comments.indexWhere((c) => c.id == comment.id);
        if (index != -1) {
          comments[index] = comment.incrementLikes();
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحديث الإعجاب');
    }
  }

  /// Update comment text
  void updateCommentText(String text) {
    newCommentText.value = text;
  }

  /// Clear comment text
  void clearCommentText() {
    newCommentText.value = '';
  }

  /// Refresh comments
  Future<void> refresh() async {
    await loadComments();
  }

  /// Get current service name
  String get serviceName {
    return _serviceController.selectedService.value?.serviceName ?? 'الخدمة';
  }
}
