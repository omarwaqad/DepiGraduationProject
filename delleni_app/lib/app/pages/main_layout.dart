// lib/app/pages/main_layout.dart
import 'package:delleni_app/app/pages/locations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/controllers/home_controller.dart';
import 'package:delleni_app/app/pages/home_content.dart'; // We'll create this
import 'package:delleni_app/app/pages/user_progress_screen.dart';
import 'package:delleni_app/app/pages/society_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final HomeController homeCtrl = Get.find<HomeController>();

  final List<Widget> _pages = [
    HomeContent(), // Just the content part without navigation
    UserProgressScreen(),
    LocationsPage(),
    SocietyPage(),
    Container(
      // Placeholder for Profile page
      child: Center(child: Text('حسابي - قيد التطوير')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Obx(() => _pages[homeCtrl.currentIndex.value]),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: homeCtrl.currentIndex.value,
            onTap: (index) {
              homeCtrl.onTabChanged(index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF219A6D),
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
