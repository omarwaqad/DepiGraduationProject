import 'package:flutter/material.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';

class StepCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isCompleted;
  final VoidCallback onTap;
  final String? subText;
  final IconData? icon;
  final bool isLast;

  const StepCard({
    Key? key,
    required this.index,
    required this.text,
    required this.isCompleted,
    required this.onTap,
    this.subText,
    this.icon,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isCompleted ? AppColors.primaryGreenLight : Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number/icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isCompleted
                      ? null
                      : Border.all(color: Colors.grey.shade400, width: 2),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : icon != null
                      ? Icon(icon, color: Colors.grey.shade700, size: 18)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الخطوة ${index + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isCompleted
                            ? AppColors.primaryGreen
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    if (subText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subText!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Status indicator
              if (isCompleted)
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;

  const StepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentStep ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index <= currentStep
                ? activeColor ?? AppColors.primaryGreen
                : inactiveColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
