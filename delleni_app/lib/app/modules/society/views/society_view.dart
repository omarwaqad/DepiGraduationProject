import 'package:delleni_app/app/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/society/controllers/society_controller.dart';
import 'package:delleni_app/app/modules/society/views/comments_view.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/comment_card.dart';
import 'package:delleni_app/app/shared/widgets/stat_card.dart';
import 'package:delleni_app/app/shared/widgets/empty_state.dart';
import 'package:delleni_app/app/shared/widgets/loading.dart';
import 'package:delleni_app/app/core/utils/helpers.dart';

class SocietyView extends StatelessWidget {
  SocietyView({Key? key}) : super(key: key);

  final SocietyController _controller = Get.put(SocietyController());
  final ServiceController _serviceController = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 12),

              // Content
              Expanded(
                child: Obx(() {
                  if (_controller.isLoadingComments.value) {
                    return const CustomLoadingIndicator(
                      message: 'جاري تحميل المشاركات...',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => _controller.refresh(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Statistics Cards
                          _buildStatisticsCards(),
                          const SizedBox(height: 14),

                          // Top Contributors
                          _buildTopContributors(),
                          const SizedBox(height: 18),

                          // All Tips
                          _buildAllTipsSection(),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'مجتمع دللي',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'شارك تجربتك واستفد من تجارب الآخرين',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ================= STATISTICS CARDS =================
  Widget _buildStatisticsCards() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatCard(
            value: _controller.topContributors.length.toString(),
            label: 'مساهمين',
            isSmall: true,
          ),
          StatCard(
            value: _controller.totalComments.value.toString(),
            label: 'تعليقات',
            isSmall: true,
          ),
          StatCard(
            value: _controller.totalLikes.value.toString(),
            label: 'إعجابات',
            isSmall: true,
          ),
        ],
      ),
    );
  }

  // ================= TOP CONTRIBUTORS =================
  Widget _buildTopContributors() {
    final contributors = _controller.topContributors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أكثر المساهمين نشاطًا',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (contributors.isEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('لا يوجد مساهمين بعد'),
          )
        else
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: contributors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final contributor = contributors[index];
                return _buildContributorChip(contributor);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildContributorChip(Contributor contributor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primaryGreenLight,
            child: Text(
              contributor.name.isNotEmpty ? contributor.name[0] : '?',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contributor.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${contributor.count} مساهمة',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= ALL TIPS SECTION =================
  Widget _buildAllTipsSection() {
    final servicesWithComments = _controller.servicesWithComments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'نصائح وتجارب المستخدمين من جميع الخدمات',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        if (servicesWithComments.isEmpty)
          EmptyState(
            title: 'لا توجد نصائح بعد',
            subtitle: 'كن أول من يشارك تجربته مع المجتمع',
            icon: Icons.forum_outlined,
          )
        else
          ...servicesWithComments.map((serviceWithComments) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service header
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 4),
                  child: Text(
                    'خدمة: ${serviceWithComments.service.serviceName}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),

                // Comments for this service
                ...serviceWithComments.comments.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildSocietyTipCard(
                      comment,
                      serviceWithComments.service.serviceName,
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildSocietyTipCard(CommentModel comment, String serviceName) {
    final timeAgoStr = Helpers.timeAgoArabic(comment.createdAt);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          // Navigate to service detail and comments
          final service = _serviceController.services.firstWhereOrNull(
            (s) => s.serviceName == serviceName,
          );
          if (service != null) {
            _serviceController.selectService(service);
            Get.to(() => CommentsView());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFEFEFEF),
                    child: Text(
                      comment.username.isNotEmpty ? comment.username[0] : '?',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.username,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeAgoStr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Service badge
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth * 0.3,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          serviceName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Comment content
              Text(
                comment.content,
                style: const TextStyle(fontSize: 13, height: 1.45),
              ),

              const SizedBox(height: 12),

              // Actions row
              Row(
                children: [
                  // Like button
                  InkWell(
                    onTap: () => _controller.likeComment(comment),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 18,
                            color: comment.likes > 0
                                ? AppColors.primaryGreen
                                : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${comment.likes}',
                            style: TextStyle(
                              fontSize: 14,
                              color: comment.likes > 0
                                  ? AppColors.primaryGreen
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
