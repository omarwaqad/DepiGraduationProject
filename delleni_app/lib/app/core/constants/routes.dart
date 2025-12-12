import 'package:get/get.dart';
import 'package:delleni_app/app/shared/layouts/main_layout.dart';
import 'package:delleni_app/app/shared/bindings/main_binding.dart';
// Import other views as needed

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String home = '/home';
  static const String serviceDetail = '/service/detail';
  static const String comments = '/comments';
  static const String locations = '/locations';
  static const String society = '/society';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String progress = '/progress';

  static List<GetPage> pages = [
    GetPage(name: main, page: () => const MainLayout(), binding: MainBinding()),
    // Add other routes here
    // GetPage(
    //   name: login,
    //   page: () => LoginView(),
    // ),
  ];
}
