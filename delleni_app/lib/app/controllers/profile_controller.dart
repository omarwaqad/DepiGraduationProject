import 'package:get/get.dart';
import 'package:delleni_app/main.dart';
import 'package:delleni_app/app/pages/login.dart';
import 'package:delleni_app/app/controllers/service_controller.dart';

class ProfileController extends GetxController {
  // Observable variables for user info
  final isLoading = true.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userInitial = ''.obs;
  
  // Observable variables for statistics
  final contributionsCount = 0.obs;
  final completedCount = 0.obs;
  final activeRequestsCount = 0.obs;
  
  // Observable variables for settings
  final notificationsEnabled = true.obs;
  final favoriteServicesCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  /// Load user information from Supabase
  Future<void> loadUserInfo() async {
    try {
      isLoading.value = true;
      
      // Get current authenticated user
      final currentUser = global.auth.currentUser;
      
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Fetch user profile from the 'users' table
      final response = await global
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      if (response != null) {
        // Parse user data
        final firstName = response['first_name'] ?? '';
        final lastName = response['last_name'] ?? '';
        final email = response['email'] ?? '';
        final phone = response['phone_number'] ?? '';
        
        // Set observable values
        userName.value = '$firstName $lastName'.trim();
        userEmail.value = email;
        userPhone.value = phone;
        
        // Generate user initial from first and last name
        String initial = '';
        if (firstName.isNotEmpty) {
          initial = firstName[0];
          if (lastName.isNotEmpty) {
            initial += lastName[0];
          }
        }
        userInitial.value = initial.toUpperCase();

        // Load statistics
        await loadUserStatistics(currentUser.id);
      }
    } catch (e) {
      print('Error loading user info: $e');
      // Set default values on error
      userName.value = 'مستخدم';
      userEmail.value = '';
      userPhone.value = '';
      userInitial.value = 'م';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user statistics (contributions, completed items, active requests)
  Future<void> loadUserStatistics(String userId) async {
    try {
      // Get ServiceController to access services and progressBox
      if (!Get.isRegistered<ServiceController>()) {
        contributionsCount.value = 0;
        completedCount.value = 0;
        activeRequestsCount.value = 0;
        favoriteServicesCount.value = 0;
        return;
      }
      
      final serviceController = Get.find<ServiceController>();
      
      int totalServices = 0;
      int completedServices = 0;
      int inProgressServices = 0;

      // Calculate from Hive progressBox like user_progress_screen
      for (var service in serviceController.services) {
        final key = '${userId}_${service.id}';
        final progress = serviceController.progressBox.get(key);
        if (progress != null && progress.stepsCompleted.any((step) => step)) {
          totalServices++;
          int completed = progress.stepsCompleted.where((s) => s).length;
          int total = service.steps.length;
          if (completed == total && total > 0) {
            completedServices++;
          } else if (completed > 0) {
            inProgressServices++;
          }
        }
      }

      // Set statistics
      contributionsCount.value = totalServices;
      completedCount.value = completedServices;
      activeRequestsCount.value = inProgressServices;

      // Fetch favorite services count from database
      try {
        final favoritesResponse =
            await global.from('favorites').select().eq('user_id', userId);
        favoriteServicesCount.value = (favoritesResponse as List).length;
      } catch (e) {
        favoriteServicesCount.value = 0;
      }
    } catch (e) {
      print('Error loading user statistics: $e');
      // Default to 0 counts on error
      contributionsCount.value = 0;
      completedCount.value = 0;
      activeRequestsCount.value = 0;
      favoriteServicesCount.value = 0;
    }
  }

  /// Toggle notifications setting
  Future<void> toggleNotifications(bool value) async {
    try {
      notificationsEnabled.value = value;
      
      // Save preference to database
      final currentUser = global.auth.currentUser;
      if (currentUser != null) {
        await global.from('users').update({
          'notifications_enabled': value,
        }).eq('id', currentUser.id);
      }
    } catch (e) {
      print('Error toggling notifications: $e');
      // Revert on error
      notificationsEnabled.value = !value;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await global.auth.signOut();
      Get.offAll(() => Login());
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تسجيل الخروج',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    await loadUserInfo();
  }
}
