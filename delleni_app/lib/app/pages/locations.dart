// lib/app/pages/locations_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:delleni_app/app/controllers/service_controller.dart';
import 'package:delleni_app/app/models/location.dart';

const Color kPrimaryGreen = Color(0xFF219A6D);
const Color kBackgroundGrey = Color(0xFFF5F5F5);

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final ServiceController ctrl = Get.find<ServiceController>();

  @override
  void initState() {
    super.initState();
    // If locations list is empty, try to fetch (keeps page reusable)
    if (ctrl.all_locations.isEmpty) {
      // This will fetch only for selected service — if you want ALL locations across services,
      // add a controller method that fetches all locations and call it instead.
      ctrl.fetchAllLocations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kBackgroundGrey,
        appBar: AppBar(
          backgroundColor: kPrimaryGreen,
          title: const Text('الأماكن'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Obx(() {
          final List<LocationModel> list = ctrl.all_locations;
          if (list.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'لا توجد مكاتب مسجلة لهذه الخدمة حالياً.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ctrl.fetchAllLocations();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final loc = list[i];
                return _LocationCard(
                  location: loc,
                  onDirections: () => _openDirections(loc),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Future<void> _openDirections(LocationModel loc) async {
    if (loc.lat == null || loc.lng == null) {
      Get.snackbar('خطأ', 'لا توجد إحداثيات لهذا المكان.');
      return;
    }

    // Ensure we have permission + current position (controller handles messages)
    await ctrl.ensureLocationPermissionAndFetch();

    // Use controller helper that opens maps (falls back to search if origin unknown)
    await ctrl.openMapsDirections(
      destinationLat: loc.lat!,
      destinationLng: loc.lng!,
      destinationName: loc.name,
    );
  }
}

class _LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onDirections;

  const _LocationCard({
    Key? key,
    required this.location,
    required this.onDirections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServiceController ctrl = Get.find<ServiceController>();
    final Position? me = ctrl.currentPosition.value;

    String distanceText() {
      if (me == null || location.lat == null || location.lng == null) return '';
      final meters = Geolocator.distanceBetween(
        me.latitude,
        me.longitude,
        location.lat!,
        location.lng!,
      );
      if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)} كم';
      return '${meters.toStringAsFixed(0)} م';
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
            // title + distance
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
                if (me != null && location.lat != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FDF8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      distanceText(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: kPrimaryGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // address
            Text(
              location.address,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // actions row (single button "اتجاهات")
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(
                      Icons.navigation_outlined,
                      size: 18,
                      color: kPrimaryGreen,
                    ),
                    label: const Text(
                      'اتجاهات',
                      style: TextStyle(color: kPrimaryGreen),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kPrimaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
