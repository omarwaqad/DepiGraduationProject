import 'package:get/get.dart';
import 'package:delleni_app/app/data/models/location_model.dart';
import 'package:delleni_app/app/data/repositories/location_repository.dart';
import 'package:delleni_app/app/core/services/location_service.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';

class LocationController extends GetxController {
  final LocationRepository _locationRepository = LocationRepository();
  final ServiceController _serviceController = Get.find<ServiceController>();

  // All locations
  final RxList<LocationModel> allLocations = <LocationModel>[].obs;

  // Filtered locations (by service or search)
  final RxList<LocationModel> filteredLocations = <LocationModel>[].obs;

  // State
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString searchQuery = ''.obs;

  // Current user location
  final RxBool hasLocationPermission = false.obs;
  final RxnDouble userLat = RxnDouble(); // nullable reactive double
  final RxnDouble userLng = RxnDouble(); // nullable reactive double

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
    loadAllLocations();
  }

  /// Check and request location permission
  Future<void> checkLocationPermission() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        userLat.value = position.latitude;
        userLng.value = position.longitude;
        hasLocationPermission.value = true;
      }
    } catch (e) {
      hasLocationPermission.value = false;
    }
  }

  /// Load all locations
  Future<void> loadAllLocations() async {
    isLoading.value = true;
    try {
      final locations = await _locationRepository.getAllLocations();
      allLocations.assignAll(locations);
      filteredLocations.assignAll(locations);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل المواقع');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load locations for current service
  Future<void> loadLocationsForCurrentService() async {
    final service = _serviceController.selectedService.value;
    if (service == null) return;

    isLoading.value = true;
    try {
      final locations = await _locationRepository.getLocationsByService(
        service.id,
      );
      filteredLocations.assignAll(locations);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل مواقع الخدمة');
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter locations by search query
  void filterLocations(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredLocations.assignAll(allLocations);
      return;
    }

    final filtered = allLocations.where((location) {
      return location.name.toLowerCase().contains(query.toLowerCase()) ||
          location.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    filteredLocations.assignAll(filtered);
  }

  /// Get nearby locations
  Future<void> showNearbyLocations(double radiusKm) async {
    if (userLat.value == null || userLng.value == null) {
      await checkLocationPermission();
      if (userLat.value == null || userLng.value == null) {
        Get.snackbar('خطأ', 'يجب تفعيل خدمة الموقع أولاً');
        return;
      }
    }

    isLoading.value = true;
    try {
      final nearbyLocations = await _locationRepository.getNearbyLocations(
        userLat.value!,
        userLng.value!,
        radiusKm,
      );
      filteredLocations.assignAll(nearbyLocations);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل المواقع القريبة');
    } finally {
      isLoading.value = false;
    }
  }

  /// Open directions to location
  Future<void> openDirections(LocationModel location) async {
    if (!location.hasCoordinates) {
      Get.snackbar('خطأ', 'لا توجد إحداثيات لهذا المكان');
      return;
    }

    // Get current location if available
    if (userLat.value == null || userLng.value == null) {
      await checkLocationPermission();
    }

    try {
      await LocationService.openMapsDirections(
        originLat: userLat.value,
        originLng: userLng.value,
        destinationLat: location.lat!,
        destinationLng: location.lng!,
        destinationName: location.name,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل فتح خرائط جوجل');
    }
  }

  /// Refresh locations
  Future<void> refreshLocations() async {
    isRefreshing.value = true;
    try {
      await loadAllLocations();
      Get.snackbar('نجاح', 'تم تحديث المواقع');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحديث المواقع');
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Clear search filter
  void clearSearch() {
    searchQuery.value = '';
    filteredLocations.assignAll(allLocations);
  }

  /// Calculate distance to location
  String? getDistanceToLocation(LocationModel location) {
    if (userLat.value == null ||
        userLng.value == null ||
        !location.hasCoordinates) {
      return null;
    }

    final meters = LocationService.calculateDistance(
      userLat.value!,
      userLng.value!,
      location.lat!,
      location.lng!,
    );

    return LocationService.formatDistance(meters);
  }

  /// Check if user has location
  bool get hasUserLocation => userLat.value != null && userLng.value != null;
}
