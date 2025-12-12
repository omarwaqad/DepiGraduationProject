part of 'service_controller.dart';

// Service fetching and selection responsibilities.
extension ServiceControllerServices on ServiceController {
  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final res = await supabase
          .from('services')
          .select()
          .order('created_at', ascending: true);

      final list = (res as List<dynamic>)
          .map((e) => Service.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      services.assignAll(list);
      _servicesCache = List<Service>.from(list);
    } catch (e) {
      // ignore: avoid_print
      print('fetchServices error: $e');
      Get.snackbar('الخدمات', 'تعذر تحميل الخدمات، حاول مرة أخرى');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectService(Service svc) async {
    selectedService.value = svc;
    await _loadProgressForService(svc);

    // Refresh contextual data for the chosen service.
    await Future.wait([
      fetchLocationsForSelectedService(),
      fetchCommentsForSelectedService(),
    ]);
  }
  // ================= SEARCH =================

  Future<void> _performSearch(String q) async {
    final query = q.trim();

    if (query.isEmpty) {
      services.assignAll(_servicesCache);
      return;
    }
    void clearSearch() {
      searchQuery.value = '';
      services.assignAll(_servicesCache);

      // Clear the TextField - you'll need to access homeCtrl
      // Or better yet, pass the TextEditingController here
    }

    // Try server search
    try {
      final res = await supabase
          .from('services')
          .select()
          .ilike('service_name', '%$query%')
          .order('created_at', ascending: false);

      final data = res as List<dynamic>;
      final results = data
          .map((e) => Service.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      services.assignAll(results);
      return;
    } catch (e) {
      print('Server search failed: $e');
    }

    // Client fallback
    final filtered = _servicesCache.where((s) {
      return s.serviceName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    services.assignAll(filtered);
  }

  void clearSearch() {
    searchQuery.value = '';
    services.assignAll(_servicesCache);
  }
}
