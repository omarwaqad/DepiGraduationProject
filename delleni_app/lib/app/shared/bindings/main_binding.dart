import 'package:get/get.dart';
import 'package:delleni_app/app/modules/home/controllers/home_controller.dart';
import 'package:delleni_app/app/modules/locations/controllers/location_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
