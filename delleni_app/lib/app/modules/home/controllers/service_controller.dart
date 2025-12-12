import 'package:delleni_app/app/modules/locations/controllers/location_controller.dart'
    show LocationController;
import 'package:delleni_app/app/modules/locations/views/location_sheet_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/data/models/service_model.dart';
import 'package:delleni_app/app/data/models/location_model.dart';
import 'package:delleni_app/app/data/models/comment_model.dart';
import 'package:delleni_app/app/data/models/user_progress_model.dart';
import 'package:delleni_app/app/data/repositories/service_repository.dart';
import 'package:delleni_app/app/data/repositories/location_repository.dart';
import 'package:delleni_app/app/data/repositories/comment_repository.dart';
import 'package:delleni_app/app/core/services/location_service.dart';

class ServiceController extends GetxController {
  final ServiceRepository _serviceRepository = ServiceRepository();
  final LocationRepository _locationRepository = LocationRepository();
  final CommentRepository _commentRepository = CommentRepository();

  // Services
  final RxList<ServiceModel> services = <ServiceModel>[].obs;
  final RxBool isLoadingServices = false.obs;

  late final LocationController locationCtrl;

  // Selected service
  final Rx<ServiceModel?> selectedService = Rx<ServiceModel?>(null);

  // Locations for selected service
  final RxList<LocationModel> locations = <LocationModel>[].obs;
  final RxBool isLoadingLocations = false.obs;

  // Comments for selected service
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoadingComments = false.obs;

  // User progress for selected service
  final Rx<UserProgressModel?> userProgress = Rx<UserProgressModel?>(null);

  // Current position
  final RxBool isLoadingLocation = false.obs;

  // Map for local comments fallback
  final Map<String, List<CommentModel>> localComments = {};

  @override
  void onInit() {
    super.onInit();
    locationCtrl = Get.find<LocationController>();
  }

  /// Fetch all services
  Future<void> fetchAllServices() async {
    isLoadingServices.value = true;
    try {
      final fetchedServices = await _serviceRepository.getAllServices();
      services.assignAll(fetchedServices);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل الخدمات');
    } finally {
      isLoadingServices.value = false;
    }
  }

  /// Select a service and load its data
  Future<void> selectService(ServiceModel service) async {
    selectedService.value = service;

    // Load locations
    await fetchLocationsForService(service.id);

    // Load comments
    await fetchCommentsForService(service.id);

    // Load or create user progress
    await loadUserProgress(service.id);
  }

  /// Fetch locations for selected service
  Future<void> fetchLocationsForService(String serviceId) async {
    isLoadingLocations.value = true;
    try {
      final fetchedLocations = await _locationRepository.getLocationsByService(
        serviceId,
      );
      locations.assignAll(fetchedLocations);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل المواقع');
    } finally {
      isLoadingLocations.value = false;
    }
  }

  /// Fetch comments for selected service
  Future<void> fetchCommentsForService(String serviceId) async {
    isLoadingComments.value = true;
    try {
      final fetchedComments = await _commentRepository.getCommentsByService(
        serviceId,
      );

      // Add local comments if any
      final local = localComments[serviceId] ?? [];
      final allComments = [...fetchedComments, ...local];
      allComments.sort(
        (a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)),
      );

      comments.assignAll(allComments);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل التعليقات');
    } finally {
      isLoadingComments.value = false;
    }
  }

  /// Load user progress
  Future<void> loadUserProgress(String serviceId) async {
    // For now, create a new progress model
    // In real app, load from Hive/SharedPreferences
    final service = selectedService.value;
    if (service != null) {
      userProgress.value = UserProgressModel.fromService(
        userId: 'current_user_id', // Get from auth
        serviceId: serviceId,
        totalSteps: service.totalSteps,
      );
    }
  }

  /// Toggle step completion
  void toggleStep(int index) {
    final progress = userProgress.value;
    if (progress != null && index >= 0 && index < progress.totalSteps) {
      userProgress.value = progress.toggleStep(index);
      // Save to storage here
    }
  }

  /// Add a comment
  Future<void> addComment(String content) async {
    final service = selectedService.value;
    if (service == null || content.trim().isEmpty) return;

    // Create temporary comment
    final tempComment = CommentModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      serviceId: service.id,
      username: 'المستخدم الحالي', // Get from auth
      content: content.trim(),
      likes: 0,
      createdAt: DateTime.now(),
    );

    // Add locally first (optimistic update)
    comments.insert(0, tempComment);

    try {
      // Try to save to server
      final savedComment = await _commentRepository.addComment(
        serviceId: service.id,
        username: 'المستخدم الحالي', // Get from auth
        content: content.trim(),
      );

      if (savedComment != null) {
        // Replace temp comment with saved one
        final index = comments.indexWhere((c) => c.id == tempComment.id);
        if (index != -1) {
          comments[index] = savedComment;
        }
      } else {
        // Save locally if server fails
        localComments[service.id] = [
          ...(localComments[service.id] ?? []),
          tempComment,
        ];
        Get.snackbar('ملاحظة', 'تم حفظ التعليق محلياً');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إضافة التعليق');
    }
  }

  /// Like a comment
  Future<void> likeComment(CommentModel comment) async {
    final index = comments.indexWhere((c) => c.id == comment.id);
    if (index != -1) {
      // Optimistic update
      comments[index] = comment.incrementLikes();

      try {
        await _commentRepository.likeComment(comment.id, comment.likes);
      } catch (e) {
        Get.snackbar('خطأ', 'فشل تحديث الإعجاب');
      }
    }
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      await LocationService.getCurrentPosition();
      Get.snackbar('نجاح', 'تم تحديد الموقع');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحديد الموقع');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Search services
  Future<void> searchServices(String query) async {
    if (query.isEmpty) {
      fetchAllServices();
      return;
    }

    isLoadingServices.value = true;
    try {
      final results = await _serviceRepository.searchServices(query);
      services.assignAll(results);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل البحث');
    } finally {
      isLoadingServices.value = false;
    }
  }

  /// Get service by ID
  ServiceModel? getServiceById(String serviceId) {
    return services.firstWhereOrNull((service) => service.id == serviceId);
  }

  /// Open locations bottom sheet
  void openLocationsSheet() async {
    final locationCtrl = Get.find<LocationController>();

    // Ask for permission before opening the sheet
    await locationCtrl.checkLocationPermission();

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSheetView(),
    );
  }
}
