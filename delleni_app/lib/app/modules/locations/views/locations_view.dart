import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/modules/locations/controllers/location_controller.dart';
import 'package:delleni_app/app/core/constants/app_constants.dart';
import 'package:delleni_app/app/shared/widgets/location_card.dart';
import 'package:delleni_app/app/shared/widgets/empty_state.dart';
import 'package:delleni_app/app/shared/widgets/loading.dart';

class LocationsView extends StatelessWidget {
  LocationsView({Key? key}) : super(key: key);

  final LocationController _controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          title: const Text('الأماكن'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _controller.isRefreshing.value
                  ? null
                  : _controller.refreshLocations,
            ),
          ],
        ),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const CustomLoadingIndicator(
              message: 'جاري تحميل المواقع...',
            );
          }

          return Column(
            children: [
              // Search and filter bar
              _buildSearchBar(),
              const SizedBox(height: 8),

              // Locations list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _controller.refreshLocations(),
                  child: _buildLocationsList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.search, color: Colors.grey, size: 20),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: _controller.filterLocations,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ابحث عن مكان...',
                        hintStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  if (_controller.searchQuery.value.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: _controller.clearSearch,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filter button
          Obx(
            () => PopupMenuButton<String>(
              icon: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: AppColors.primaryGreen,
                ),
              ),
              onSelected: (value) {
                if (value == 'nearby') {
                  _controller.showNearbyLocations(5.0); // 5km radius
                } else if (value == 'all') {
                  _controller.clearSearch();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'all',
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('جميع الأماكن'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'nearby',
                  child: Row(
                    children: [
                      Icon(Icons.near_me_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('الأماكن القريبة'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOCATIONS LIST =================
  Widget _buildLocationsList() {
    final locations = _controller.filteredLocations;

    if (locations.isEmpty) {
      return EmptyState(
        title: _controller.searchQuery.value.isEmpty
            ? 'لا توجد مكاتب مسجلة'
            : 'لا توجد نتائج للبحث',
        subtitle: _controller.searchQuery.value.isEmpty
            ? 'سيتم إضافة المكاتب قريباً'
            : 'جرب مصطلحات بحث أخرى',
        icon: Icons.place_outlined,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      itemCount: locations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final location = locations[index];
        final distance = _controller.getDistanceToLocation(location);

        return LocationCard(
          location: location,
          userLat: _controller.userLat.value,
          userLng: _controller.userLng.value,
          showDistance: distance != null,
          onDirections: () => _controller.openDirections(location),
        );
      },
    );
  }
}
