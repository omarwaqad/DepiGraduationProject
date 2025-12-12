import 'package:delleni_app/app/data/models/location_model.dart';
import 'package:delleni_app/app/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LocationRepository {
  SupabaseClient get _supabase => SupabaseService.instance;

  /// Get locations for a specific service
  Future<List<LocationModel>> getLocationsByService(String serviceId) async {
    try {
      final response = await _supabase
          .from('locations')
          .select()
          .eq('service_id', serviceId)
          .order('name', ascending: true);

      final data = response as List<dynamic>;
      return data.map((e) => LocationModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all locations
  Future<List<LocationModel>> getAllLocations() async {
    try {
      final response = await _supabase
          .from('locations')
          .select()
          .order('name', ascending: true);

      final data = response as List<dynamic>;
      return data.map((e) => LocationModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Search locations by name or address
  Future<List<LocationModel>> searchLocations(String query) async {
    try {
      final response = await _supabase
          .from('locations')
          .select()
          .or('name.ilike.%$query%,address.ilike.%$query%')
          .order('name', ascending: true);

      final data = response as List<dynamic>;
      return data.map((e) => LocationModel.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get nearby locations
  Future<List<LocationModel>> getNearbyLocations(
    double userLat,
    double userLng,
    double radiusInKm,
  ) async {
    try {
      final allLocations = await getAllLocations();

      return allLocations.where((location) {
        if (!location.hasCoordinates) return false;

        // Simple distance calculation (for demo)
        // In production, use PostGIS with Supabase
        final latDiff = (location.lat! - userLat).abs();
        final lngDiff = (location.lng! - userLng).abs();

        // Rough approximation (1 degree ≈ 111 km)
        final distanceKm = (latDiff + lngDiff) * 111;
        return distanceKm <= radiusInKm;
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
