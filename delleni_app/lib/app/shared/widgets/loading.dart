import 'package:flutter/material.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const CustomLoadingIndicator({
    Key? key,
    this.message,
    this.color,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primaryGreen,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerLoading({
    Key? key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
    );
  }
}
