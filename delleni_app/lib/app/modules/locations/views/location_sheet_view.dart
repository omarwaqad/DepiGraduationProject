import 'package:delleni_app/app/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/locations/controllers/location_controller.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/location_card.dart';

class LocationSheetView extends StatelessWidget {
  LocationSheetView({super.key});

  final LocationController _controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            height: 6,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 12),

          // Title
          const Text(
            'مواقع الخدمة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Locations list
          Expanded(
            child: Obx(() {
              final locations = _controller.filteredLocations;

              if (locations.isEmpty) {
                return const Center(child: Text('لا توجد مواقع لهذه الخدمة'));
              }

              return ListView.separated(
                itemCount: locations.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final distance = _controller.getDistanceToLocation(location);

                  return LocationListTile(
                    location: location,
                    onTap: () => _openLocation(location, distance),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _openLocation(LocationModel location, String? distance) async {
    // Close the sheet
    Get.back();

    // Show snackbar
    Get.snackbar(
      'فتح الخرائط',
      'الاتجاهات إلى ${location.name}${distance != null ? ' • $distance' : ''}',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Open maps
    await _controller.openDirections(location);
  }
}

class LocationListTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onTap;

  const LocationListTile({
    Key? key,
    required this.location,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryGreenLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.place_outlined,
          color: AppColors.primaryGreen,
          size: 20,
        ),
      ),
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
      trailing: const Icon(
        Icons.navigation_outlined,
        color: AppColors.primaryGreen,
      ),
      onTap: onTap,
    );
  }
}
