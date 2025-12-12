import 'package:delleni_app/app/controllers/profile_controller.dart';
import 'package:delleni_app/app/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2E9B6F),
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Profile
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E9B6F), Color(0xFF43B883)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  MediaQuery.of(context).padding.top + 20,
                  screenWidth * 0.05,
                  30,
                ),
                child: Column(
                  children: [
                    Text(
                      'الملف الشخصي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // Profile Card
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Profile Avatar
                          Container(
                            width: isSmallScreen ? 60 : 70,
                            height: isSmallScreen ? 60 : 70,
                            decoration: BoxDecoration(
                              color: Color(0xFF2E9B6F),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                controller.userInitial.value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 28 : 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 15),

                          // User Info
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.userName.value,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  controller.userEmail.value,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 11 : 13,
                                    color: Colors.grey[500],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                                if (controller.userPhone.value.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      controller.userPhone.value,
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 11 : 13,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Spacer(),

                          // // Settings Icon
                          // IconButton(
                          //   onPressed: () {
                          //   Get.to(() => SettingsPage());
                          //   },
                          //   icon: Icon(Icons.settings_outlined),
                          //   color: Colors.grey[400],
                          //   iconSize: isSmallScreen ? 20 : 24,
                          // ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            controller.contributionsCount.value.toString(),
                            'مساهمة',
                            Colors.white,
                            Colors.grey[800]!,
                            isSmallScreen,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: _buildStatCard(
                            controller.completedCount.value.toString(),
                            'تم إنجازه',
                            Colors.white,
                            Color(0xFFFF9800),
                            isSmallScreen,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: _buildStatCard(
                            controller.activeRequestsCount.value.toString(),
                            'طلبات نشطة',
                            Colors.white,
                            Color(0xFF2E9B6F),
                            isSmallScreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Settings Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Settings Card
                    _buildSettingCard(
                      icon: Icons.settings_outlined,
                      title: 'إعدادات الحساب',
                      subtitle: 'تعديل المعلومات الشخصية',
                      trailing: Icon(Icons.chevron_left, color: Colors.grey[400]),
                      onTap: () {
                        Get.to(() => SettingsPage());
                      },
                      isSmallScreen: isSmallScreen,
                    ),
                    
                    SizedBox(height: 16),
                    
                    // App Info Section
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'دليلي - طريقك للأوراق الحكومية',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'الإصدار 1.0.0',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 4,
                            children: [
                              _buildInfoLink('اتصل بنا', isSmallScreen),
                              Text(' • ', style: TextStyle(color: Colors.grey[400])),
                              _buildInfoLink('شروط الاستخدام', isSmallScreen),
                              Text(' • ', style: TextStyle(color: Colors.grey[400])),
                              _buildInfoLink('سياسة الخصوصية', isSmallScreen),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Logout Button
                    InkWell(
                      onTap: () => controller.logout(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFFF5252),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Color(0xFFFF5252),
                              size: isSmallScreen ? 18 : 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF5252),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String number, String label, Color bg, Color textColor, bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isSmall ? 16 : 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: isSmall ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 10 : 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    required bool isSmallScreen,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                color: Color(0xFF2E9B6F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Color(0xFF2E9B6F),
                size: isSmallScreen ? 20 : 24,
              ),
            ),

            SizedBox(width: 12),

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),

            Spacer(),

            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLink(String text, bool isSmall) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isSmall ? 9 : 11,
        color: Colors.grey[600],
        decoration: TextDecoration.underline,
      ),
    );
  }
}