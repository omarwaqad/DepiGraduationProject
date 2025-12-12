import 'package:get/get.dart';
import 'package:delleni_app/app/data/models/user_model.dart';
import 'package:delleni_app/app/data/repositories/user_repository.dart';
import 'package:delleni_app/app/data/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final AuthRepository _authRepository = AuthRepository();

  // User data
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Statistics
  final RxInt contributionsCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxInt activeRequestsCount = 0.obs;
  final RxInt favoritesCount = 0.obs;

  // Settings
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load user profile and statistics
  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      // Get current user
      final currentUser = await _authRepository.getCurrentUser();
      user.value = currentUser;

      if (currentUser != null) {
        // Load user profile from database
        final fullProfile = await _userRepository.getUserProfile(
          currentUser.id,
        );
        if (fullProfile != null) {
          user.value = fullProfile;
        }

        // Load user statistics
        await loadUserStatistics(currentUser.id);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل بيانات المستخدم');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user statistics
  Future<void> loadUserStatistics(String userId) async {
    try {
      final stats = await _userRepository.getUserStatistics(userId);

      contributionsCount.value = stats['contributions'] ?? 0;
      favoritesCount.value = stats['favorites'] ?? 0;
      completedCount.value = stats['completed'] ?? 0;
      activeRequestsCount.value = stats['active'] ?? 0;
    } catch (e) {
      // Use default values if statistics fail
      contributionsCount.value = 0;
      favoritesCount.value = 0;
      completedCount.value = 0;
      activeRequestsCount.value = 0;
    }
  }

  /// Refresh user data
  Future<void> refreshProfile() async {
    isRefreshing.value = true;
    try {
      await loadUserProfile();
      Get.snackbar(
        'نجاح',
        'تم تحديث البيانات',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحديث البيانات');
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
  }) async {
    final currentUser = user.value;
    if (currentUser == null) return false;

    isLoading.value = true;
    try {
      final success = await _userRepository.updateUserProfile(
        userId: currentUser.id,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
      );

      if (success) {
        // Update local user object
        user.value = currentUser.copyWith(
          firstName: firstName ?? currentUser.firstName,
          lastName: lastName ?? currentUser.lastName,
          phoneNumber: phoneNumber ?? currentUser.phoneNumber,
          address: address ?? currentUser.address,
          updatedAt: DateTime.now(),
        );

        Get.snackbar(
          'نجاح',
          'تم تحديث الملف الشخصي',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar('خطأ', 'فشل تحديث الملف الشخصي');
        return false;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء التحديث');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    // Here you would save to backend
    Get.snackbar('إعدادات', 'تم ${value ? 'تفعيل' : 'تعطيل'} الإشعارات');
  }

  /// Logout user
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      user.value = null;
      clearData();
      Get.offAllNamed('/login');
      Get.snackbar('نجاح', 'تم تسجيل الخروج بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تسجيل الخروج');
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all data
  void clearData() {
    user.value = null;
    contributionsCount.value = 0;
    completedCount.value = 0;
    activeRequestsCount.value = 0;
    favoritesCount.value = 0;
  }

  /// Get user initials for avatar
  String get userInitials {
    final currentUser = user.value;
    if (currentUser == null) return 'م';
    return currentUser.initials;
  }

  /// Get user full name
  String get userName {
    final currentUser = user.value;
    if (currentUser == null) return 'مستخدم';
    return currentUser.fullName;
  }

  /// Get user email
  String get userEmail {
    final currentUser = user.value;
    if (currentUser == null) return '';
    return currentUser.email;
  }

  /// Get user phone
  String get userPhone {
    final currentUser = user.value;
    if (currentUser == null) return '';
    return currentUser.phoneNumber ?? '';
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _authRepository.isAuthenticated();
}
