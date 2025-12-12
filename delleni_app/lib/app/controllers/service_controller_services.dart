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
}
