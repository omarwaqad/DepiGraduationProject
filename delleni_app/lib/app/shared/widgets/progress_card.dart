import 'package:flutter/material.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/core/utils/helpers.dart';

class ProgressCard extends StatelessWidget {
  final int completed;
  final int total;
  final VoidCallback? onTap;
  final String? title;
  final Color? progressColor;
  final Color? backgroundColor;

  const ProgressCard({
    Key? key,
    required this.completed,
    required this.total,
    this.onTap,
    this.title,
    this.progressColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;
    final percent = (progress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? 'التقدم الكلي',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '$completed من $total  •  $percent٪',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E5E5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (completed > 0 && completed < total)
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 12, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'متبقي ${total - completed} خطوة',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            if (completed == total && total > 0)
              Row(
                children: [
                  Icon(Icons.check_circle, size: 12, color: AppColors.success),
                  const SizedBox(width: 4),
                  const Text(
                    'مكتمل ✓',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class CircularProgressIndicatorCard extends StatelessWidget {
  final double progress;
  final String label;
  final String value;
  final Color? color;
  final double size;

  const CircularProgressIndicatorCard({
    Key? key,
    required this.progress,
    required this.label,
    required this.value,
    this.color,
    this.size = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    color ?? AppColors.primaryGreen,
                  ),
                ),
                Text(
                  Helpers.formatPercentage(progress),
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
