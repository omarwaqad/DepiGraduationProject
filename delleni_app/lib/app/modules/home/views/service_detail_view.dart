import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';
import 'package:delleni_app/app/modules/society/views/comments_view.dart';
import 'package:delleni_app/app/modules/locations/views/location_sheet_view.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/progress_card.dart';
import 'package:delleni_app/app/shared/widgets/step_card.dart';

class ServiceDetailView extends StatelessWidget {
  ServiceDetailView({Key? key}) : super(key: key);

  final ServiceController _controller = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    final service = _controller.selectedService.value;

    if (service == null) {
      Future.microtask(() => Get.back());
      return const Scaffold(body: SizedBox.shrink());
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context, service.serviceName),
                Obx(() {
                  final progress = _controller.userProgress.value;
                  final totalSteps = service.steps.length;
                  final completedSteps = progress?.completedCount ?? 0;

                  return Column(
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -24),
                        child: ProgressCard(
                          completed: completedSteps,
                          total: totalSteps,
                          onTap: () {
                            // Show progress details if needed
                          },
                        ),
                      ),
                      _buildQuickInfoRow(),
                      _buildDocumentsSection(service),
                      _buildStepsSection(service),
                      const SizedBox(height: 12),
                      _buildCommentsButton(),
                      const SizedBox(height: 16),
                      _buildActionButton(),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'دليلك الشامل لإتمام الإجراء',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ================= QUICK INFO ROW =================
  Widget _buildQuickInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              icon: Icons.access_time_rounded,
              iconColor: AppColors.primaryGreen,
              label: 'المدة المتوقعة',
              value: '7-10 أيام',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _openLocationsSheet(),
              child: _buildInfoCard(
                icon: Icons.location_on_rounded,
                iconColor: AppColors.secondaryOrange,
                label: 'أقرب مكتب',
                value: 'عرض المواقع',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= DOCUMENTS SECTION =================
  Widget _buildDocumentsSection(service) {
    if (service.requiredPapers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryGreenLight,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الأوراق المطلوبة',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            ...service.requiredPapers.map(
              (doc) => Padding(
                padding: const EdgeInsets.only(bottom: 4, right: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        doc,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STEPS SECTION =================
  Widget _buildStepsSection(service) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخطوات المطلوبة',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(service.steps.length, (index) {
              final stepText = service.steps[index];
              final isCompleted =
                  _controller.userProgress.value?.stepsCompleted[index] ??
                  false;

              return StepCard(
                index: index,
                text: stepText,
                isCompleted: isCompleted,
                onTap: () => _controller.toggleStep(index),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ================= COMMENTS BUTTON =================
  Widget _buildCommentsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryGreen),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Get.to(() => CommentsView());
          },
          icon: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primaryGreen,
            size: 20,
          ),
          label: const Text(
            'اضف تعليقك',
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // ================= ACTION BUTTON =================
  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          onPressed: () {
            // Start the process
            Get.snackbar(
              'نجاح',
              'بدأت عملية ${_controller.selectedService.value?.serviceName}',
            );
          },
          child: const Text(
            'ابدأ الإجراء الآن',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ================= OPEN LOCATION SHEET =================
  void _openLocationsSheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationSheetView(),
    );
  }
}
