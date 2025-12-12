import 'package:flutter/material.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSmall;

  const StatCard({
    Key? key,
    required this.value,
    required this.label,
    this.color,
    this.textColor,
    this.icon,
    this.onTap,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isSmall ? 16 : 20,
          horizontal: isSmall ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(isSmall ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: isSmall ? 10 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? AppColors.primaryGreen,
                size: isSmall ? 24 : 28,
              ),
              SizedBox(height: isSmall ? 8 : 12),
            ],
            Text(
              value,
              style: TextStyle(
                fontSize: isSmall ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: textColor ?? AppColors.textPrimary,
              ),
            ),
            SizedBox(height: isSmall ? 4 : 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isSmall ? 10 : 12,
                color: textColor?.withOpacity(0.8) ?? AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const ProfileStatCard({
    Key? key,
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
