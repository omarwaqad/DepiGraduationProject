import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';
import 'package:delleni_app/app/modules/home/views/service_detail_view.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/service_card.dart';

class HomeContentView extends StatelessWidget {
  HomeContentView({Key? key}) : super(key: key);

  final ServiceController _serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildVisionBanner(),
              const SizedBox(height: 16),
              _buildServicesTitle(),
              const SizedBox(height: 8),
              _buildServicesSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مرحباً 👋',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'كيف يمكننا مساعدتك اليوم؟',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: Colors.grey, size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: 'ابحث عن خدمة...',
                    ),
                    style: TextStyle(fontSize: 14),
                    cursorColor: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= VISION BANNER =================
  Widget _buildVisionBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryOrange,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'رؤيتنا 🚀',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'نحو تحول رقمي كامل - إنترنت سريع وغير محدود لدعم الابتكار والمستقبلين ونمو الوطن',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SERVICES TITLE =================
  Widget _buildServicesTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          'الخدمات المتاحة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // ================= SERVICES SECTION =================
  Widget _buildServicesSection() {
    return Obx(() {
      if (_serviceController.isLoadingServices.value) {
        return const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (_serviceController.services.isEmpty) {
        return const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              'لا توجد خدمات متاحة حالياً.',
              style: TextStyle(fontSize: 14),
            ),
          ),
        );
      }

      return _buildServicesGrid();
    });
  }

  // ================= SERVICES GRID =================
  Widget _buildServicesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _serviceController.services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
        ),
        itemBuilder: (context, index) {
          final service = _serviceController.services[index];

          return ServiceCard(
            service: service,
            onTap: () {
              _serviceController.selectService(service);
              Get.to(() => ServiceDetailView());
            },
          );
        },
      ),
    );
  }
}
