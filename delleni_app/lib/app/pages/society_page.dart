// lib/app/pages/society_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/controllers/service_controller.dart';
import 'package:delleni_app/app/controllers/society_controller.dart';
import 'package:delleni_app/app/models/comments.dart';

const Color kPrimaryGreen = Color(0xFF219A6D);
const Color kBackgroundGrey = Color(0xFFF5F5F5);

class SocietyPage extends StatelessWidget {
  const SocietyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final societyCtrl = Get.put(SocietyController());
    final ServiceController serviceCtrl = Get.find<ServiceController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBackgroundGrey,
        body: SafeArea(
          child: Column(
            children: [
              _HeaderArea(),
              const SizedBox(height: 12),
              Expanded(
                child: Obx(() {
                  if (societyCtrl.isLoadingComments.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kPrimaryGreen,
                      ),
                    );
                  }

                  // Get all comments grouped by service
                  final allComments = societyCtrl.getCommentsGroupedByService(serviceCtrl);

                  // Calculate totals
                  int totalComments = 0;
                  int totalLikes = societyCtrl.getTotalLikes();
                  for (final entry in allComments) {
                    final comments = entry['comments'] as List<CommentModel>;
                    totalComments += comments.length;
                  }

                  final contributors = societyCtrl.getTopContributors(limit: 5);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatsCard(
                          totalContributors: contributors.length,
                          totalTips: totalComments,
                          totalLikes: totalLikes,
                        ),
                        const SizedBox(height: 14),

                        // Most active contributors
                        const Text(
                          'أكثر المساهمين نشاطًا',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
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
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, i) {
                                final item = contributors[i];
                                return _ContributorChip(
                                  name: item.key,
                                  count: item.value,
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 18),

                        // Tips feed (all comments from all services)
                        const Text(
                          'نصائح وتجارب المستخدمين من جميع الخدمات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Display comments grouped by service
                        if (allComments.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.forum_outlined,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'لا توجد نصائح بعد',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'كن أول من يشارك تجربته مع المجتمع',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else
                          ...allComments.map((serviceEntry) {
                            final serviceName =
                                serviceEntry['serviceName'] as String;
                            final serviceComments =
                                serviceEntry['comments'] as List<CommentModel>;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Service header
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                    top: 4,
                                  ),
                                  child: Text(
                                    'خدمة: $serviceName',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryGreen,
                                    ),
                                  ),
                                ),

                                // Comments for this service
                                ...serviceComments.map(
                                  (c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _SocietyTipCard(
                                      comment: c,
                                      serviceName: serviceName,
                                      onLike: () => serviceCtrl.likeComment(c),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),
                              ],
                            );
                          }),

                        const SizedBox(height: 80),
                      ],
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
}

// ---------------- UI pieces ----------------

class _HeaderArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimaryGreen, Color(0xFF1C815B)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'مجتمع دلني',
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
}

class _StatsCard extends StatelessWidget {
  final int totalContributors;
  final int totalTips;
  final int totalLikes;

  const _StatsCard({
    Key? key,
    required this.totalContributors,
    required this.totalTips,
    required this.totalLikes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          _StatItem(count: totalContributors.toString(), label: 'مساهمين'),
          _StatItem(count: totalTips.toString(), label: 'تعليقات'),
          _StatItem(count: totalLikes.toString(), label: 'إعجابات'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({Key? key, required this.count, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _ContributorChip extends StatelessWidget {
  final String name;
  final int count;

  const _ContributorChip({Key? key, required this.name, required this.count})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: const Color(0xFFF0F0F0),
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$count مساهمة',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocietyTipCard extends StatelessWidget {
  final CommentModel comment;
  final String serviceName;
  final VoidCallback onLike;

  const _SocietyTipCard({
    Key? key,
    required this.comment,
    required this.serviceName,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeAgoStr = _timeAgoArabic(comment.createdAt);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header row: avatar + name + badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFEFEFEF),
                  child: Text(
                    comment.username?.isNotEmpty == true
                        ? comment.username![0]
                        : '?',
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
                        comment.username ?? 'مستخدم',
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
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.3,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FFF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    serviceName,
                    style: const TextStyle(fontSize: 12, color: kPrimaryGreen),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // comment content
            Text(
              comment.content ?? '',
              style: const TextStyle(fontSize: 13, height: 1.45),
            ),
            const SizedBox(height: 12),
            // actions row (only likes; no replies)
            Row(
              children: [
                InkWell(
                  onTap: onLike,
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
                          color: (comment.likes ?? 0) > 0
                              ? kPrimaryGreen
                              : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${comment.likes ?? 0}',
                          style: TextStyle(
                            fontSize: 14,
                            color: (comment.likes ?? 0) > 0
                                ? kPrimaryGreen
                                : Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () {
                    // TODO: Implement reply functionality
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.reply_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'رد',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
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
    );
  }
}

// ---------------- helpers ----------------

String _timeAgoArabic(DateTime? dt) {
  if (dt == null) return 'منذ وقت غير معلوم';

  final Duration diff = DateTime.now().difference(dt);

  if (diff.inMinutes < 1) {
    return 'منذ لحظات';
  } else if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return 'منذ $m دقيقة';
  } else if (diff.inHours < 24) {
    final h = diff.inHours;
    return 'منذ $h ساعة';
  } else if (diff.inDays == 1) {
    return 'منذ يوم';
  } else if (diff.inDays < 7) {
    return 'منذ ${diff.inDays} أيام';
  } else {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
