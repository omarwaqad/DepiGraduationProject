import 'package:delleni_app/app/bindings/auth_binding.dart';
import 'package:delleni_app/app/bindings/service_binding.dart';
import 'package:delleni_app/app/controllers/home_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Eagerly resolve auth + service to ensure Get.find works immediately on first page
    AuthBinding().dependencies();
    ServiceBinding().dependencies();
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
