import 'package:get/get.dart';
import 'package:delleni_app/app/data/models/comment_model.dart';
import 'package:delleni_app/app/data/models/service_model.dart';
import 'package:delleni_app/app/data/repositories/comment_repository.dart';
import 'package:delleni_app/app/data/repositories/service_repository.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';

class SocietyController extends GetxController {
  final CommentRepository _commentRepository = CommentRepository();
  final ServiceRepository _serviceRepository = ServiceRepository();

  // All comments from all services
  final RxList<CommentModel> allComments = <CommentModel>[].obs;
  final RxBool isLoadingComments = false.obs;

  // Services with their comments
  final RxList<ServiceWithComments> servicesWithComments =
      <ServiceWithComments>[].obs;

  // Statistics
  final RxInt totalComments = 0.obs;
  final RxInt totalLikes = 0.obs;
  final RxList<Contributor> topContributors = <Contributor>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllComments();
  }

  /// Load all comments from all services
  Future<void> loadAllComments() async {
    isLoadingComments.value = true;
    try {
      // Get all comments
      final comments = await _commentRepository.getAllComments();
      allComments.assignAll(comments);

      // Calculate statistics
      calculateStatistics();

      // Get services and group comments
      await groupCommentsByService();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل التعليقات');
    } finally {
      isLoadingComments.value = false;
    }
  }

  /// Calculate statistics from all comments
  void calculateStatistics() {
    // Total comments
    totalComments.value = allComments.length;

    // Total likes
    totalLikes.value = allComments.fold(
      0,
      (sum, comment) => sum + comment.likes,
    );

    // Top contributors
    final contributorMap = <String, int>{};
    for (final comment in allComments) {
      final username = comment.username;
      contributorMap[username] = (contributorMap[username] ?? 0) + 1;
    }

    final contributorsList =
        contributorMap.entries
            .map((entry) => Contributor(name: entry.key, count: entry.value))
            .toList()
          ..sort((a, b) => b.count.compareTo(a.count));

    topContributors.assignAll(contributorsList.take(5));
  }

  /// Group comments by their service
  Future<void> groupCommentsByService() async {
    try {
      // Get all services
      final services = await _serviceRepository.getAllServices();

      // Group comments by service
      final grouped = <ServiceWithComments>[];

      for (final service in services) {
        final serviceComments =
            allComments
                .where((comment) => comment.serviceId == service.id)
                .toList()
              ..sort(
                (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
                  a.createdAt ?? DateTime(0),
                ),
              );

        if (serviceComments.isNotEmpty) {
          grouped.add(
            ServiceWithComments(service: service, comments: serviceComments),
          );
        }
      }

      // Sort by most recent comment
      grouped.sort((a, b) {
        if (a.comments.isEmpty && b.comments.isEmpty) return 0;
        if (a.comments.isEmpty) return 1;
        if (b.comments.isEmpty) return -1;

        final aLatest = a.comments.first.createdAt ?? DateTime(0);
        final bLatest = b.comments.first.createdAt ?? DateTime(0);

        return bLatest.compareTo(aLatest);
      });

      servicesWithComments.assignAll(grouped);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تجميع التعليقات');
    }
  }

  /// Add a new comment
  Future<void> addComment({
    required String serviceId,
    required String content,
    String? username,
  }) async {
    if (content.trim().isEmpty) return;

    final currentUsername = username ?? 'مستخدم';

    try {
      final newComment = await _commentRepository.addComment(
        serviceId: serviceId,
        username: currentUsername,
        content: content.trim(),
      );

      if (newComment != null) {
        // Add to all comments
        allComments.insert(0, newComment);

        // Update statistics
        calculateStatistics();

        // Update grouping
        await groupCommentsByService();

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
        // Update comment in list
        final index = allComments.indexWhere((c) => c.id == comment.id);
        if (index != -1) {
          allComments[index] = comment.incrementLikes();
          calculateStatistics();
          await groupCommentsByService();
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحديث الإعجاب');
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadAllComments();
  }

  /// Get comments for a specific service
  List<CommentModel> getCommentsForService(String serviceId) {
    return allComments
        .where((comment) => comment.serviceId == serviceId)
        .toList();
  }

  /// Get service name by ID
  String getServiceName(String serviceId) {
    final serviceWithComments = servicesWithComments.firstWhereOrNull(
      (item) => item.service.id == serviceId,
    );
    return serviceWithComments?.service.serviceName ?? 'خدمة';
  }
}

/// Model for service with its comments
class ServiceWithComments {
  final ServiceModel service;
  final List<CommentModel> comments;

  ServiceWithComments({required this.service, required this.comments});
}

/// Model for top contributor
class Contributor {
  final String name;
  final int count;

  Contributor({required this.name, required this.count});
}
