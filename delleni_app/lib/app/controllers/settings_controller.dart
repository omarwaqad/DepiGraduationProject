import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:delleni_app/app/controllers/profile_controller.dart';
import 'package:delleni_app/main.dart';

class SettingsController extends GetxController {
  final isLoading = true.obs;
  final isSaving = false.obs;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCurrentData();
  }

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }

  Future<void> loadCurrentData() async {
    try {
      isLoading.value = true;

      final currentUser = global.auth.currentUser;
      if (currentUser == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على مستخدم نشط');
        return;
      }

      final response = await global
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      if (response != null) {
        firstNameCtrl.text = (response['first_name'] ?? '').toString();
        lastNameCtrl.text = (response['last_name'] ?? '').toString();
        phoneCtrl.text = (response['phone_number'] ?? '').toString();
      }
    } catch (e) {
      print('Error loading settings data: $e');
      Get.snackbar('خطأ', 'تعذر تحميل بيانات الحساب');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveChanges() async {
    final first = firstNameCtrl.text.trim();
    final last = lastNameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();

    if (first.isEmpty || last.isEmpty) {
      Get.snackbar('تنبيه', 'الاسم الأول واسم العائلة مطلوبان');
      return;
    }

    try {
      isSaving.value = true;
      final currentUser = global.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No active user');
      }

      await global.from('users').update({
        'first_name': first,
        'last_name': last,
        'phone_number': phone,
      }).eq('id', currentUser.id);

      if (Get.isRegistered<ProfileController>()) {
        final profile = Get.find<ProfileController>();
        profile.userName.value = '$first $last'.trim();
        profile.userPhone.value = phone;

        final initial = '${first.isNotEmpty ? first[0] : ''}${last.isNotEmpty ? last[0] : ''}'
            .toUpperCase();
        profile.userInitial.value = initial;
      }

      Get.snackbar(
        'تم الحفظ',
        'تم تحديث معلوماتك بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error saving settings: $e');
      Get.snackbar('خطأ', 'تعذر حفظ التغييرات');
    } finally {
      isSaving.value = false;
    }
  }
}
