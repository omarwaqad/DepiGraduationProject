import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/profile/controllers/profile_controller.dart';

class SettingsController extends GetxController {
  final ProfileController _profileController = Get.find<ProfileController>();

  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // State
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  /// Load current user data into form
  Future<void> loadCurrentData() async {
    isLoading.value = true;
    try {
      final user = _profileController.user.value;
      if (user != null) {
        firstNameController.text = user.firstName ?? '';
        lastNameController.text = user.lastName ?? '';
        phoneController.text = user.phoneNumber ?? '';
        emailController.text = user.email;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل البيانات');
    } finally {
      isLoading.value = false;
    }
  }

  /// Save changes to profile
  Future<void> saveChanges() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    // Validate
    if (firstName.isEmpty || lastName.isEmpty) {
      Get.snackbar('تنبيه', 'الاسم الأول واسم العائلة مطلوبان');
      return;
    }

    isSaving.value = true;
    try {
      final success = await _profileController.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phone.isNotEmpty ? phone : null,
      );

      if (success) {
        Get.back();
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل حفظ التغييرات');
    } finally {
      isSaving.value = false;
    }
  }

  /// Reset form to current values
  void resetForm() {
    final user = _profileController.user.value;
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      phoneController.text = user.phoneNumber ?? '';
    }
  }

  /// Check if form has changes
  bool get hasChanges {
    final user = _profileController.user.value;
    if (user == null) return false;

    return firstNameController.text.trim() != (user.firstName ?? '') ||
        lastNameController.text.trim() != (user.lastName ?? '') ||
        phoneController.text.trim() != (user.phoneNumber ?? '');
  }
}
