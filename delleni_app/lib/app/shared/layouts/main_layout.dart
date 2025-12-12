import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/home/controllers/home_controller.dart';
import 'package:delleni_app/app/modules/home/views/home_view.dart';
import 'package:delleni_app/app/modules/progress/views/progress_view.dart';
import 'package:delleni_app/app/modules/locations/views/locations_view.dart';
import 'package:delleni_app/app/modules/society/views/society_view.dart';
import 'package:delleni_app/app/modules/profile/views/profile_view.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final HomeController _homeController = Get.find<HomeController>();

  final List<Widget> _pages = [
    HomeView(),
    ProgressView(),
    LocationsView(),
    SocietyView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Obx(() => _pages[_homeController.currentIndex]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: _homeController.currentIndex,
            onTap: (index) {
              _homeController.changeTab(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryGreen,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'الرئيسية',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long_rounded),
                label: 'طلباتي',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.place_outlined),
                activeIcon: Icon(Icons.place_rounded),
                label: 'الأماكن',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_outlined),
                activeIcon: Icon(Icons.groups_rounded),
                label: 'المجتمع',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
