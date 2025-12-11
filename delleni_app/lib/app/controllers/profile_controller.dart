import 'package:get/get.dart';
import 'package:delleni_app/main.dart';

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
      // Fetch contributions count
      final contributionsResponse =
          await global.from('contributions').select().eq('user_id', userId);
      contributionsCount.value = (contributionsResponse as List).length;

      // Fetch completed items count
      final completedResponse = await global
          .from('user_services')
          .select()
          .eq('user_id', userId)
          .eq('status', 'completed');
      completedCount.value = (completedResponse as List).length;

      // Fetch active requests count
      final activeResponse = await global
          .from('user_services')
          .select()
          .eq('user_id', userId)
          .neq('status', 'completed')
          .neq('status', 'cancelled');
      activeRequestsCount.value = (activeResponse as List).length;

      // Fetch favorite services count
      final favoritesResponse =
          await global.from('favorites').select().eq('user_id', userId);
      favoriteServicesCount.value = (favoritesResponse as List).length;
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
      Get.offAllNamed('/login');
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
