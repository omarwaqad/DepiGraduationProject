import 'package:flutter/material.dart';
import 'package:delleni_app/app/data/models/service_model.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? customIcon;

  const ServiceCard({
    Key? key,
    required this.service,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.customIcon,
  }) : super(key: key);

  // Icon map for different services
  static final Map<String, IconData> _serviceIcons = {
    'قيد عائلي': Icons.family_restroom_rounded,
    'تقديم الجامعات': Icons.school_rounded,
    'طلب وظيفة حكومية': Icons.work_rounded,
    'استخراج الباسبور': Icons.flight_takeoff_rounded,
    'اشتراك المترو': Icons.directions_subway_filled_rounded,
    'التامين الصحى': Icons.medical_services_rounded,
    'استخراج بطاقة الرقم القومى': Icons.credit_card_rounded,
    'تجديد الباسبور': Icons.autorenew_rounded,
    'رخصة القيادة الشخصية': Icons.badge_rounded,
    'رخصة السيارة': Icons.directions_car_filled_rounded,
  };

  // Background color map
  static final Map<String, Color> _serviceColors = {
    'قيد عائلي': AppColors.primaryGreenLight,
    'تقديم الجامعات': const Color(0xFFFFF2EE),
    'طلب وظيفة حكومية': AppColors.primaryGreenLight,
    'استخراج الباسبور': const Color(0xFFFFF2EE),
    'اشتراك المترو': AppColors.primaryGreenLight,
    'التامين الصحى': const Color(0xFFFFF2EE),
    'استخراج بطاقة الرقم القومى': AppColors.primaryGreenLight,
    'تجديد الباسبور': const Color(0xFFFFF2EE),
    'رخصة القيادة الشخصية': AppColors.primaryGreenLight,
    'رخصة السيارة': const Color(0xFFFFF2EE),
  };

  @override
  Widget build(BuildContext context) {
    final icon =
        customIcon ??
        _serviceIcons[service.serviceName] ??
        Icons.widgets_rounded;
    final bgColor =
        backgroundColor ??
        _serviceColors[service.serviceName] ??
        AppColors.primaryGreenLight;

    return Material(
      elevation: 1.5,
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      shadowColor: Colors.black.withOpacity(0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryGreen, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                service.serviceName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (service.hasSteps || service.hasRequiredPapers) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (service.hasSteps)
                      Row(
                        children: [
                          const Icon(
                            Icons.list_alt,
                            size: 10,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${service.totalSteps} خطوات',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    if (service.hasSteps && service.hasRequiredPapers)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '•',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                    if (service.hasRequiredPapers)
                      Row(
                        children: [
                          const Icon(
                            Icons.description,
                            size: 10,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${service.requiredPapers.length} أوراق',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
