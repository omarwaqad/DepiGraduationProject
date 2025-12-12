part of 'service_controller.dart';

// Location fetching helpers.
extension ServiceControllerLocations on ServiceController {
  Future<void> fetchLocationsForSelectedService() async {
    final svc = selectedService.value;
    if (svc == null) {
      locations.clear();
      return;
    }

    try {
      final res = await supabase
          .from('locations')
          .select()
          .eq('service_id', svc.id)
          .order('name');

      final list = (res as List<dynamic>)
          .map((e) => LocationModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      locations.assignAll(list);
    } catch (e) {
      // ignore: avoid_print
      print('fetchLocationsForSelectedService error: $e');
      Get.snackbar('الأماكن', 'تعذر تحميل الأماكن حالياً');
    }
  }

  Future<void> fetchAllLocations() async {
    try {
      final res = await supabase.from('locations').select().order('name');
      final list = (res as List<dynamic>)
          .map((e) => LocationModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      locations.assignAll(list);
    } catch (e) {
      // ignore: avoid_print
      print('fetchAllLocations error: $e');
      Get.snackbar('الأماكن', 'تعذر تحميل الأماكن حالياً');
    }
  }
}
