import 'package:delleni_app/app/data/models/service_model.dart';
import 'package:delleni_app/app/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceRepository {
  // Don't initialize _supabase in the constructor
  // Use a getter instead so it's called when needed
  SupabaseClient get _supabase => SupabaseService.instance;

  Future<List<ServiceModel>> getAllServices() async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((e) => ServiceModel.fromMap(e)).toList();
    } catch (e) {
      print('Error fetching services: $e');
      return [];
    }
  }

  /// Get service by ID
  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .eq('id', serviceId)
          .single();

      return ServiceModel.fromMap(response);
    } catch (e) {
      print('Error fetching service by ID: $e');
      return null;
    }
  }

  /// Search services by name
  Future<List<ServiceModel>> searchServices(String query) async {
    try {
      final response = await _supabase
          .from('services')
          .select()
          .ilike('service_name', '%$query%')
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      return data.map((e) => ServiceModel.fromMap(e)).toList();
    } catch (e) {
      print('Error searching services: $e');
      return [];
    }
  }
}
