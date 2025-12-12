import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/data/models/location_model.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/core/services/location_service.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onDirections;
  final double? userLat;
  final double? userLng;
  final bool showDistance;

  const LocationCard({
    Key? key,
    required this.location,
    required this.onDirections,
    this.userLat,
    this.userLng,
    this.showDistance = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String distanceText = '';

    if (showDistance &&
        userLat != null &&
        userLng != null &&
        location.hasCoordinates) {
      final meters = LocationService.calculateDistance(
        userLat!,
        userLng!,
        location.lat!,
        location.lng!,
      );
      distanceText = LocationService.formatDistance(meters);
    }

    return Material(
      elevation: 1.2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + distance
            Row(
              children: [
                Expanded(
                  child: Text(
                    location.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (distanceText.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreenLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      distanceText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Address
            Text(
              location.address,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Actions row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(
                      Icons.navigation_outlined,
                      size: 18,
                      color: AppColors.primaryGreen,
                    ),
                    label: const Text(
                      'اتجاهات',
                      style: TextStyle(color: AppColors.primaryGreen),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (location.hasCoordinates)
                  IconButton(
                    icon: const Icon(
                      Icons.copy_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Copy coordinates
                      Get.snackbar('تم النسخ', 'نسخت الإحداثيات');
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationListTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;
  final bool showIcon;
  final IconData? customIcon;

  const LocationListTile({
    Key? key,
    required this.location,
    required this.onTap,
    this.showIcon = true,
    this.customIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: showIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryGreenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                customIcon ?? Icons.place_outlined,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            )
          : null,
      title: Text(
        location.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        location.address,
        style: const TextStyle(fontSize: 13),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: location.hasCoordinates
          ? const Icon(Icons.navigation_outlined, color: AppColors.primaryGreen)
          : null,
      onTap: onTap,
    );
  }
}
