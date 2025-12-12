import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:delleni_app/app/modules/profile/views/settings_view.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/stat_card.dart';
import 'package:delleni_app/app/shared/widgets/settings_item.dart';
import 'package:delleni_app/app/shared/widgets/empty_state.dart';
import 'package:delleni_app/app/shared/widgets/loading.dart';

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);

  final ProfileController _controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const CustomLoadingIndicator(
            message: 'جاري تحميل البيانات...',
          );
        }

        return RefreshIndicator(
          onRefresh: () => _controller.refreshProfile(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with Profile
                Container(
                  decoration: BoxDecoration(
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
                    30,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'الملف الشخصي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Profile Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Profile Avatar
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  _controller.userInitials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            // User Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _controller.userName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _controller.userEmail,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (_controller.userPhone.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        _controller.userPhone,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Statistics Cards
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              value: _controller.contributionsCount.value
                                  .toString(),
                              label: 'مساهمة',
                              color: Colors.white,
                              textColor: Colors.grey[800],
                              isSmall: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: StatCard(
                              value: _controller.completedCount.value
                                  .toString(),
                              label: 'تم إنجازه',
                              color: Colors.white,
                              textColor: AppColors.secondaryOrange,
                              isSmall: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: StatCard(
                              value: _controller.activeRequestsCount.value
                                  .toString(),
                              label: 'طلبات نشطة',
                              color: Colors.white,
                              textColor: AppColors.primaryGreen,
                              isSmall: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Settings Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Settings Card
                      SettingsItem(
                        icon: Icons.settings_outlined,
                        title: 'إعدادات الحساب',
                        subtitle: 'تعديل المعلومات الشخصية',
                        onTap: () {
                          Get.to(() => SettingsView());
                        },
                      ),

                      const SizedBox(height: 16),

                      // Notifications Settings
                      SettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'الإشعارات',
                        subtitle: 'إدارة الإشعارات والتحديثات',
                        trailing: Obx(
                          () => Switch(
                            value: _controller.notificationsEnabled.value,
                            onChanged: _controller.toggleNotifications,
                            activeColor: AppColors.primaryGreen,
                          ),
                        ),
                        onTap: () {
                          _controller.toggleNotifications(
                            !_controller.notificationsEnabled.value,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // App Info Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'دليلي - طريقك للأوراق الحكومية',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'الإصدار 1.0.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 4,
                              children: [
                                _buildInfoLink('اتصل بنا'),
                                Text(
                                  ' • ',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                _buildInfoLink('شروط الاستخدام'),
                                Text(
                                  ' • ',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                _buildInfoLink('سياسة الخصوصية'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Logout Button
                      InkWell(
                        onTap: () => _showLogoutConfirmation(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red, width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'تسجيل الخروج',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.grey,
        decoration: TextDecoration.underline,
      ),
    );
  }

  void _showLogoutConfirmation() {
    Get.defaultDialog(
      title: 'تأكيد تسجيل الخروج',
      middleText: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
      textConfirm: 'نعم، سجل الخروج',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () => _controller.logout(),
      onCancel: () => Get.back(),
    );
  }
}
