import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/profile/controllers/settings_controller.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/custom_text_field.dart';
import 'package:delleni_app/app/shared/widgets/custom_button.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);

  final SettingsController _controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.primaryGreenDark,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    MediaQuery.of(context).padding.top + 20,
                    16,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'إعدادات الحساب',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '.حدّث اسمك أو رقم هاتفك وسيتم حفظهما في حسابك',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Form
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // First Name
                      CustomTextField(
                        controller: _controller.firstNameController,
                        label: 'الاسم الأول',
                        hintText: 'أدخل الاسم الأول',
                        isRequired: true,
                      ),
                      const SizedBox(height: 14),

                      // Last Name
                      CustomTextField(
                        controller: _controller.lastNameController,
                        label: 'اسم العائلة',
                        hintText: 'أدخل اسم العائلة',
                        isRequired: true,
                      ),
                      const SizedBox(height: 14),

                      // Phone
                      CustomTextField(
                        controller: _controller.phoneController,
                        label: 'رقم الهاتف',
                        hintText: 'أدخل رقم الهاتف',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 14),

                      // Email (read-only)
                      CustomTextField(
                        controller: _controller.emailController,
                        label: 'البريد الإلكتروني',
                        enabled: false,
                      ),

                      const SizedBox(height: 24),

                      // Save Button
                      const SizedBox(height: 12),

                      // Reset Button
                      if (_controller.hasChanges)
                        CustomOutlinedButton(
                          text: 'إعادة تعيين',
                          onPressed: _controller.resetForm,
                          width: double.infinity,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
