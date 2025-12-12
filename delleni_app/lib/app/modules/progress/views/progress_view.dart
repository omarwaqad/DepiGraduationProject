import 'package:delleni_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/progress/controllers/progress_controller.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';
import 'package:delleni_app/app/modules/home/views/service_detail_view.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/stat_card.dart';
import 'package:delleni_app/app/shared/widgets/progress_card.dart';
import 'package:delleni_app/app/shared/widgets/empty_state.dart';
import 'package:delleni_app/app/shared/widgets/loading.dart';
import 'package:delleni_app/app/core/utils/helpers.dart';

class ProgressView extends StatelessWidget {
  ProgressView({Key? key}) : super(key: key);

  final ProgressController _progressController = Get.put(ProgressController());
  final ServiceController _serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          slivers: [
            // Header with gradient and stats
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreenDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 40 : 20,
                  MediaQuery.of(context).padding.top + 60,
                  isTablet ? 40 : 20,
                  40,
                ),
                child: Column(
                  children: [
                    const Text(
                      'تتبع طلباتك',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'متابعة حالة جميع إجراءاتك الحكومية',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    // Stats cards
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              value: _progressController.totalServices.value
                                  .toString(),
                              label: 'الإجمالي',
                              color: Colors.white,
                              textColor: AppColors.primaryGreen,
                              isSmall: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              value: _progressController
                                  .inProgressServices
                                  .value
                                  .toString(),
                              label: 'قيد التنفيذ',
                              color: Colors.white,
                              textColor: const Color(0xFFFF9800),
                              isSmall: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              value: _progressController.completedServices.value
                                  .toString(),
                              label: 'مكتمل',
                              color: Colors.white,
                              textColor: AppColors.primaryGreen,
                              isSmall: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 40 : 20,
                  35,
                  isTablet ? 40 : 20,
                  20,
                ),
                child: Text(
                  'طلباتك الحالية',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),

            // Services List
            Obx(() {
              if (_progressController.isLoading.value) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                );
              }

              final servicesWithProgress = _progressController
                  .getServicesWithProgress();

              /*
              if (servicesWithProgress.isEmpty) {

                return SliverFillRemaining(
                  child: EmptyState(
                    title: 'لا توجد طلبات قيد المتابعة',
                    subtitle: 'ابدأ بتقديم خدمة من الصفحة الرئيسية',
                    icon: Icons.track_changes_outlined,
                    action: () {
                      // Navigate to home
                      action:
                      () {
                        // Navigate to home
                        Get.find<HomeController>().currentIndex.value = 0;
                      };
                    },
                    actionText: 'تصفح الخدمات',
                  ),
                );
              }*/

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 40 : 20,
                  vertical: 10,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = servicesWithProgress[index];
                    return _buildServiceCard(item, isTablet);
                  }, childCount: servicesWithProgress.length),
                ),
              );
            }),

            // Bottom padding
            SliverToBoxAdapter(child: SizedBox(height: isTablet ? 40 : 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceWithProgress item, bool isTablet) {
    final service = item.service;
    final progress = item.progress;
    final percentage = item.completionPercentage;
    final isComplete = item.isCompleted;

    return GestureDetector(
      onTap: () {
        _serviceController.selectService(service);
        Get.to(() => ServiceDetailView());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 20 : 16),
        padding: EdgeInsets.all(isTablet ? 22 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: isTablet ? 16 : 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(isTablet ? 13 : 12),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? AppColors.primaryGreen.withOpacity(0.1)
                        : const Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
                  ),
                  child: Icon(
                    isComplete ? Icons.check_circle : Icons.description,
                    color: isComplete
                        ? AppColors.primaryGreen
                        : const Color(0xFFFF9800),
                    size: isTablet ? 30 : 28,
                  ),
                ),
                // Title and date
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: isTablet ? 16 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          service.serviceName,
                          style: TextStyle(
                            fontSize: isTablet ? 19 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isTablet ? 6 : 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Helpers.formatDateArabic(progress.lastUpdated),
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 13,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 22 : 20),

            // Progress section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.completedSteps} من ${item.totalSteps}',
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isComplete ? 'مكتمل' : 'قيد المراجعة',
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: isTablet ? 14 : 12),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: isTablet ? 9 : 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete ? AppColors.primaryGreen : AppColors.primaryGreen,
                ),
              ),
            ),

            SizedBox(height: isTablet ? 14 : 12),

            // Percentage badge
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 14 : 12,
                  vertical: isTablet ? 7 : 6,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(percentage * 100).toInt()}% مكتمل',
                  style: TextStyle(
                    fontSize: isTablet ? 13 : 12,
                    fontWeight: FontWeight.bold,
                    color: isComplete
                        ? AppColors.primaryGreen
                        : const Color(0xFFFF9800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
