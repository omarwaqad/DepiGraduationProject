import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  /// Current tab in BottomNavigationBar
  final RxInt currentIndex = 0.obs;

  final searchController = TextEditingController(); // Add this

  void onTabChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    searchController.dispose(); // Clean up
    super.onClose();
  }
}
