import 'package:get/get.dart';
import 'package:delleni_app/app/controllers/service_controller.dart';
import 'package:delleni_app/app/models/comments.dart';

class SocietyController extends GetxController {
  final isLoadingComments = false.obs;
  final allComments = <CommentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllComments();
  }

  Future<void> loadAllComments() async {
    try {
      isLoadingComments.value = true;
      
      if (!Get.isRegistered<ServiceController>()) {
        isLoadingComments.value = false;
        return;
      }

      final serviceCtrl = Get.find<ServiceController>();
      final comments = await serviceCtrl.fetchAllComments();
      
      allComments.value = comments;
    } catch (e) {
      print('Error loading all comments: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  /// Get all comments grouped by service
  List<Map<String, dynamic>> getCommentsGroupedByService(ServiceController ctrl) {
    final result = <Map<String, dynamic>>[];

    // For each service, get its comments
    for (final service in ctrl.services) {
      // Filter comments for this service from the fetched list
      final serviceComments = allComments
          .where((c) => c.serviceId == service.id)
          .toList();

      // Sort by date (newest first)
      serviceComments.sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );

      if (serviceComments.isNotEmpty) {
        result.add({
          'serviceId': service.id,
          'serviceName': service.serviceName,
          'comments': serviceComments,
        });
      }
    }

    // Sort services by most recent comment
    result.sort((a, b) {
      final aComments = a['comments'] as List<CommentModel>;
      final bComments = b['comments'] as List<CommentModel>;

      if (aComments.isEmpty && bComments.isEmpty) return 0;
      if (aComments.isEmpty) return 1;
      if (bComments.isEmpty) return -1;

      final aLatest = aComments.first.createdAt ?? DateTime(0);
      final bLatest = bComments.first.createdAt ?? DateTime(0);

      return bLatest.compareTo(aLatest);
    });

    return result;
  }

  /// Get top contributors from all comments
  List<MapEntry<String, int>> getTopContributors({int limit = 5}) {
    final Map<String, int> counts = {};
    for (final c in allComments) {
      final name = (c.username ?? 'غير معروف');
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }

  /// Calculate total likes across all comments
  int getTotalLikes() {
    int total = 0;
    for (final comment in allComments) {
      total += comment.likes ?? 0;
    }
    return total;
  }

  /// Refresh comments
  Future<void> refresh() async {
    await loadAllComments();
  }
}
