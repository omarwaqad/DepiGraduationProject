import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  /// Check and request location permissions
  static Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('خطأ', 'خدمات الموقع معطلة.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('خطأ', 'تم رفض أذونات الموقع.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'خطأ',
        'تم رفض أذونات الموقع بشكل دائم، يرجى تمكينها من الإعدادات.',
      );
      return false;
    }

    return true;
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      if (!await checkAndRequestPermission()) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في الحصول على الموقع الحالي.');
      return null;
    }
  }

  /// Get address from coordinates
  static Future<String> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    try {
      final places = await placemarkFromCoordinates(lat, lng);
      if (places.isNotEmpty) {
        final place = places.first;
        return '${place.street}, ${place.locality}, ${place.country}';
      }
      return 'عنوان غير معروف';
    } catch (e) {
      return 'فشل في الحصول على العنوان';
    }
  }

  /// Calculate distance between two points in meters
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  /// Format distance to readable string
  static String formatDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} كم';
    }
    return '${meters.toStringAsFixed(0)} م';
  }

  /// Open maps for directions
  static Future<void> openMapsDirections({
    double? originLat,
    double? originLng,
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    final origin = (originLat != null && originLng != null)
        ? '$originLat,$originLng'
        : '';
    final dest = '$destinationLat,$destinationLng';

    final uri = Uri.parse(
      origin.isNotEmpty
          ? 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$dest&travelmode=driving'
          : 'https://www.google.com/maps/search/?api=1&query=$dest',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('خرائط', 'تعذر فتح خرائط جوجل.');
    }
  }
}
