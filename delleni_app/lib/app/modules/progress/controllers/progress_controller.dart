import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:delleni_app/app/data/models/service_model.dart';
import 'package:delleni_app/app/data/models/user_progress_model.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';
import 'package:delleni_app/app/core/services/supabase_service.dart';

class ProgressController extends GetxController {
  final ServiceController _serviceController = Get.find<ServiceController>();

  // Hive box for user progress
  late Box<UserProgressModel> progressBox;

  // Progress data
  final RxList<UserProgressModel> userProgressList = <UserProgressModel>[].obs;
  final RxBool isLoading = false.obs;

  // Statistics
  final RxInt totalServices = 0.obs;
  final RxInt completedServices = 0.obs;
  final RxInt inProgressServices = 0.obs;
  final RxInt pendingServices = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  /// Initialize Hive
  Future<void> _initHive() async {
    progressBox = await Hive.openBox<UserProgressModel>('user_progress');
    loadUserProgress();
  }

  /// Load all user progress
  Future<void> loadUserProgress() async {
    isLoading.value = true;
    try {
      // Get current user ID
      final userId = SupabaseService.instance.auth.currentUser?.id;
      if (userId == null) {
        userProgressList.clear();
        calculateStatistics();
        return;
      }

      // Load all progress for this user
      final allProgress = progressBox.values
          .where((progress) => progress.userId == userId)
          .toList();

      userProgressList.assignAll(allProgress);
      calculateStatistics();
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل تقدم المستخدم');
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculate statistics
  void calculateStatistics() {
    totalServices.value = 0;
    completedServices.value = 0;
    inProgressServices.value = 0;
    pendingServices.value = 0;

    for (final progress in userProgressList) {
      if (progress.hasProgress) {
        totalServices.value++;

        if (progress.isCompleted) {
          completedServices.value++;
        } else if (progress.hasProgress) {
          inProgressServices.value++;
        }
      }
    }
  }

  /// Get progress for a specific service
  UserProgressModel? getProgressForService(String serviceId) {
    final userId = SupabaseService.instance.auth.currentUser?.id;
    if (userId == null) return null;

    final key = _generateKey(userId, serviceId);
    return progressBox.get(key);
  }

  /// Create or update progress for a service
  Future<void> updateProgressForService({
    required String serviceId,
    required List<bool> stepsCompleted,
  }) async {
    final userId = SupabaseService.instance.auth.currentUser?.id;
    if (userId == null) return;

    final key = _generateKey(userId, serviceId);
    final existingProgress = progressBox.get(key);

    final newProgress = existingProgress != null
        ? existingProgress.updateSteps(stepsCompleted)
        : UserProgressModel(
            userId: userId,
            serviceId: serviceId,
            stepsCompleted: stepsCompleted,
            lastUpdated: DateTime.now(),
          );

    await progressBox.put(key, newProgress);
    await loadUserProgress(); // Refresh the list
  }

  /// Toggle a step for a service
  Future<void> toggleStep(String serviceId, int stepIndex) async {
    final userId = SupabaseService.instance.auth.currentUser?.id;
    if (userId == null) return;

    final key = _generateKey(userId, serviceId);
    final existingProgress = progressBox.get(key);

    if (existingProgress != null &&
        stepIndex < existingProgress.stepsCompleted.length) {
      final newProgress = existingProgress.toggleStep(stepIndex);
      await progressBox.put(key, newProgress);
      await loadUserProgress();
    }
  }

  /// Delete progress for a service
  Future<void> deleteProgress(String serviceId) async {
    final userId = SupabaseService.instance.auth.currentUser?.id;
    if (userId == null) return;

    final key = _generateKey(userId, serviceId);
    await progressBox.delete(key);
    await loadUserProgress();

    Get.snackbar('نجاح', 'تم حذف التقدم');
  }

  /// Get services with progress
  List<ServiceWithProgress> getServicesWithProgress() {
    final services = _serviceController.services;
    final result = <ServiceWithProgress>[];

    for (final progress in userProgressList) {
      final service = services.firstWhereOrNull(
        (s) => s.id == progress.serviceId,
      );
      if (service != null && progress.hasProgress) {
        result.add(ServiceWithProgress(service: service, progress: progress));
      }
    }

    // Sort by last updated (newest first)
    result.sort(
      (a, b) => b.progress.lastUpdated.compareTo(a.progress.lastUpdated),
    );

    return result;
  }

  /// Get services by status
  List<ServiceWithProgress> getServicesByStatus(String status) {
    final allServices = getServicesWithProgress();

    return allServices.where((item) {
      if (status == 'completed') {
        return item.progress.isCompleted;
      } else if (status == 'in_progress') {
        return item.progress.hasProgress && !item.progress.isCompleted;
      } else if (status == 'pending') {
        return !item.progress.hasProgress;
      }
      return true;
    }).toList();
  }

  /// Reset all progress (for debugging/testing)
  Future<void> resetAllProgress() async {
    final userId = SupabaseService.instance.auth.currentUser?.id;
    if (userId == null) return;

    // Delete all progress for current user
    final keysToDelete = <String>[];
    for (final progress in progressBox.values) {
      if (progress.userId == userId) {
        final key = _generateKey(userId, progress.serviceId);
        keysToDelete.add(key);
      }
    }

    for (final key in keysToDelete) {
      await progressBox.delete(key);
    }

    await loadUserProgress();
    Get.snackbar('نجاح', 'تم إعادة تعيين جميع التقدم');
  }

  /// Generate Hive key
  String _generateKey(String userId, String serviceId) {
    return '${userId}_$serviceId';
  }

  /// Refresh progress data
  Future<void> refresh() async {
    await loadUserProgress();
  }

  /// Check if user has any progress
  bool get hasProgress => userProgressList.isNotEmpty;
}

/// Model for service with its progress
class ServiceWithProgress {
  final ServiceModel service;
  final UserProgressModel progress;

  ServiceWithProgress({required this.service, required this.progress});

  double get completionPercentage => progress.completionPercentage;
  int get completedSteps => progress.completedCount;
  int get totalSteps => progress.totalSteps;
  bool get isCompleted => progress.isCompleted;
  DateTime get lastUpdated => progress.lastUpdated;
}
