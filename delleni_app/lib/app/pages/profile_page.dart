import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/controllers/profile_controller.dart';

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
                          // Settings Icon
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.settings_outlined),
                            color: Colors.grey[400],
                            iconSize: isSmallScreen ? 20 : 24,
                          ),
                          
                          Spacer(),
                          
                          // User Info
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  controller.userName.value,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  controller.userEmail.value,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 11 : 13,
                                    color: Colors.grey[500],
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          SizedBox(width: 15),
                          
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
              
              // Settings & Preferences Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الإعدادات والتفضيلات',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Notifications Toggle
                    _buildSettingCard(
                      icon: Icons.notifications_outlined,
                      title: 'الإشعارات',
                      subtitle: 'إدارة تنبيهات التطبيق',
                      trailing: Switch(
                        value: controller.notificationsEnabled.value,
                        onChanged: (value) {
                          controller.toggleNotifications(value);
                        },
                        activeColor: Color(0xFF2E9B6F),
                      ),
                      isSmallScreen: isSmallScreen,
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Favorite Services
                    _buildSettingCard(
                      icon: Icons.star_outline,
                      title: 'الخدمات المفضلة',
                      subtitle: '${controller.favoriteServicesCount.value} خدمات محفوظة',
                      trailing: Icon(Icons.chevron_left, color: Colors.grey[400]),
                      onTap: () {},
                      isSmallScreen: isSmallScreen,
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Settings
                    _buildSettingCard(
                      icon: Icons.settings_outlined,
                      title: 'الإعدادات',
                      subtitle: 'تخصيص التطبيق',
                      trailing: Icon(Icons.chevron_left, color: Colors.grey[400]),
                      onTap: () {},
                      isSmallScreen: isSmallScreen,
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Achievements Section
                    // Text(
                    //   'الإنجازات',
                    //   style: TextStyle(
                    //     fontSize: isSmallScreen ? 16 : 18,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.grey[800],
                    //   ),
                    // ),
                    
                    SizedBox(height: 16),
                    
                    // Active User Badge
                    // Container(
                    //   padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [Color(0xFFFFF4E6), Color(0xFFFFE5CC)],
                    //       begin: Alignment.topRight,
                    //       end: Alignment.bottomLeft,
                    //     ),
                    //     borderRadius: BorderRadius.circular(16),
                    //     border: Border.all(
                    //       color: Color(0xFFFFD699),
                    //       width: 1.5,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       // Emoji Icons
                    //       Column(
                    //         children: [
                    //           Text('⭐', style: TextStyle(fontSize: isSmallScreen ? 16 : 20)),
                    //           SizedBox(height: 4),
                    //           Text('📋', style: TextStyle(fontSize: isSmallScreen ? 16 : 20)),
                    //         ],
                    //       ),
                          
                    //       SizedBox(width: 15),
                          
                    //       Spacer(),
                          
                    //       // Text Content
                    //       Flexible(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.end,
                    //           children: [
                    //             Text(
                    //               'مستخدم نشط',
                    //               style: TextStyle(
                    //                 fontSize: isSmallScreen ? 16 : 18,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.grey[800],
                    //               ),
                    //             ),
                    //             SizedBox(height: 6),
                    //             Text(
                    //               'أكملت ${controller.completedCount.value} إجراء حكومي بنجاح!',
                    //               style: TextStyle(
                    //                 fontSize: isSmallScreen ? 11 : 13,
                    //                 color: Colors.grey[600],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                          
                    //       SizedBox(width: 15),
                          
                    //       // Badge Icon
                    //       Container(
                    //         width: isSmallScreen ? 60 : 70,
                    //         height: isSmallScreen ? 60 : 70,
                    //         decoration: BoxDecoration(
                    //           gradient: LinearGradient(
                    //             colors: [Color(0xFFFFB347), Color(0xFFFF9800)],
                    //             begin: Alignment.topLeft,
                    //             end: Alignment.bottomRight,
                    //           ),
                    //           borderRadius: BorderRadius.circular(16),
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Color(0xFFFF9800).withOpacity(0.3),
                    //               blurRadius: 10,
                    //               offset: Offset(0, 4),
                    //             ),
                    //           ],
                    //         ),
                    //         child: Icon(
                    //           Icons.emoji_events,
                    //           color: Colors.white,
                    //           size: isSmallScreen ? 30 : 36,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    
                    SizedBox(height: 20),
                    
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'دليلي - طريقك للأوراق الحكومية',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'الإصدار 1.0.0',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            alignment: WrapAlignment.end,
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
            trailing,
            
            Spacer(),
            
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 12),
            
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