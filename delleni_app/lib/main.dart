// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String supabaseUrl = 'https://zfrllrwqndzgfwbtnokl.supabase.co';
  const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmcmxscndxbmR6Z2Z3YnRub2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMDg3MjgsImV4cCI6MjA3OTY4NDcyOH0.gXvK2t3X_bUtd9EU9NjViSxcu6Whab5jq1lGUvus3sU';


  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Now Supabase.instance exists → safe
  Get.put(ServiceController());

  runApp(MyApp());
}


/// Simple Service model
class Service {
  final String id;
  final DateTime? createdAt;
  final String serviceName;
  final List<String> requiredPapers;
  final List<String> steps;

  Service({
    required this.id,
    required this.serviceName,
    this.createdAt,
    required this.requiredPapers,
    required this.steps,
  });

  factory Service.fromMap(Map<String, dynamic> m) {
    // required_papers and steps come as List<dynamic> or String (in some cases)
    List<String> toStrList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      // if returned as a string like {"a","b"} we won't parse it here
      return [v.toString()];
    }

    return Service(
      id: m['id'].toString(),
      createdAt: m['created_at'] != null ? DateTime.tryParse(m['created_at']) : null,
      serviceName: m['service_name'] ?? '',
      requiredPapers: toStrList(m['required_papers']),
      steps: toStrList(m['steps']),
    );
  }
}

/// Location model (for "see nearest location" button)
class LocationModel {
  final String id;
  final String serviceId;
  final String name;
  final String address;
  final double? lat;
  final double? lng;

  LocationModel({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.address,
    this.lat,
    this.lng,
  });

  factory LocationModel.fromMap(Map<String, dynamic> m) {
    return LocationModel(
      id: m['id'].toString(),
      serviceId: m['service_id'].toString(),
      name: m['name'] ?? '',
      address: m['address'] ?? '',
      lat: m['lat'] is num ? (m['lat'] as num).toDouble() : null,
      lng: m['lng'] is num ? (m['lng'] as num).toDouble() : null,
    );
  }
}

/// Comment model
class CommentModel {
  final String id;
  final String serviceId;
  final String content;
  final DateTime? createdAt;

  CommentModel({
    required this.id,
    required this.serviceId,
    required this.content,
    this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> m) {
    return CommentModel(
      id: m['id'].toString(),
      serviceId: m['service_id'].toString(),
      content: m['content'] ?? '',
      createdAt: m['created_at'] != null ? DateTime.tryParse(m['created_at']) : null,
    );
  }
}

/// Controller — fetches services & controls current selected service state
class ServiceController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var services = <Service>[].obs;

  // Selected service and per-step completion status are reactive
  var selectedService = Rxn<Service>();
  var stepCompleted = <bool>[].obs;

  // Locations and comments for the selected service
  var locations = <LocationModel>[].obs;
  var comments = <CommentModel>[].obs;
  var isCommentsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      final res = await supabase.from('services').select().order('created_at', ascending: false);
      // supabase returns List<dynamic>
      // if (res.error != null) {
      //   // In newer supabase_flutter, errors are thrown; still handle defensively
      //   print('Supabase error: ${res.error}');
      //   return;
      // }
      final data = res as List<dynamic>;
      services.value = data.map((e) {
        if (e is Map<String, dynamic>) return Service.fromMap(e);
        return Service.fromMap(Map<String, dynamic>.from(e as Map));
      }).toList();
    } catch (e, st) {
      print('fetchServices error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  void selectService(Service service) {
    selectedService.value = service;
    // initialize step completion list to false for each step
    stepCompleted.value = List<bool>.filled(service.steps.length, false);
    // clear previous locations/comments
    locations.clear();
    comments.clear();
  }

  void toggleStep(int index) {
    if (index < 0 || index >= stepCompleted.length) return;
    stepCompleted[index] = !stepCompleted[index];
    // Force update
    stepCompleted.refresh();
  }

  /// Fetch locations related to selected service.
  /// Assumes a `locations` table with columns: id, service_id, name, address, lat, lng
  Future<void> fetchLocationsForSelectedService() async {
    final svc = selectedService.value;
    if (svc == null) return;
    try {
      final res = await supabase
          .from('locations')
          .select()
          .eq('service_id', svc.id)
          .order('name', ascending: true);
      final list = (res as List<dynamic>).map((e) => LocationModel.fromMap(Map<String, dynamic>.from(e))).toList();
      locations.value = list;
    } catch (e) {
      print('fetchLocations error: $e');
    }
  }

  /// Fetch comments for selected service. Assumes a `comments` table with: id, service_id, content, created_at
  Future<void> fetchCommentsForSelectedService() async {
    final svc = selectedService.value;
    if (svc == null) return;
    try {
      isCommentsLoading.value = true;
      final res = await supabase
          .from('comments')
          .select()
          .eq('service_id', svc.id)
          .order('created_at', ascending: true);
      final list = (res as List<dynamic>).map((e) => CommentModel.fromMap(Map<String, dynamic>.from(e))).toList();
      comments.value = list;
    } catch (e) {
      print('fetchComments error: $e');
    } finally {
      isCommentsLoading.value = false;
    }
  }

  /// Add comment to the comments table
  Future<void> addComment(String content) async {
    final svc = selectedService.value;
    if (svc == null) return;
    try {
      final insertRes = await supabase.from('comments').insert({
        'service_id': svc.id,
        'content': content,
      }).select().single();
      // After insert, fetch comments again (or append)
      await fetchCommentsForSelectedService();
    } catch (e) {
      print('addComment error: $e');
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final green = Colors.green.shade700;
    return GetMaterialApp(
      title: 'Delleni Services',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: green,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
          secondary: green,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        // textTheme: TextTheme(
        //   bodyText1: TextStyle(color: Colors.black),
        //   bodyText2: TextStyle(color: Colors.black),
        //   headline6: TextStyle(color: Colors.black),
        // ),
      ),
      home: HomePage(),
    );
  }
}

/// Home: list of services
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final ServiceController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delleni — Services', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (ctrl.services.isEmpty) {
          return Center(child: Text('No services found.'));
        }
        return ListView.separated(
          padding: EdgeInsets.all(12),
          itemCount: ctrl.services.length,
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemBuilder: (context, i) {
            final s = ctrl.services[i];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 2,
              child: ListTile(
                title: Text(s.serviceName),
                subtitle: Text('${s.requiredPapers.length} required papers · ${s.steps.length} steps'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  ctrl.selectService(s);
                  Get.to(() => ServiceDetailPage());
                },
              ),
            );
          },
        );
      }),
    );
  }
}

/// Service detail: papers, steps, two buttons
class ServiceDetailPage extends StatelessWidget {
  ServiceDetailPage({Key? key}) : super(key: key);

  final ServiceController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    final svc = ctrl.selectedService.value;
    if (svc == null) {
      // shouldn't happen, redirect back
      Future.microtask(() => Get.back());
      return Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(svc.serviceName, style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Required papers
            Align(alignment: Alignment.centerLeft, child: Text('Required Papers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: svc.requiredPapers.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: Icon(Icons.note),
                    title: Text(svc.requiredPapers[i]),
                  );
                },
              ),
            ),

            SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: Text('Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            SizedBox(height: 8),

            // Steps with checkboxes
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: svc.steps.length,
                itemBuilder: (context, i) {
                  return Obx(() {
                    return CheckboxListTile(
                      key: ValueKey(i),
                      title: Text('${i + 1}. ${svc.steps[i]}'),
                      value: ctrl.stepCompleted[i],
                      onChanged: (_) => ctrl.toggleStep(i),
                    );
                  });
                },
              ),
            ),






            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ctrl.fetchLocationsForSelectedService();
                      Get.bottomSheet(
                        LocationsSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                      );
                    },
                    icon: Icon(Icons.place),
                    label: Text('See nearest location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await ctrl.fetchCommentsForSelectedService();
                      Get.to(() => CommentsPage());
                    },
                    icon: Icon(Icons.forum),
                    label: Text('Open discussion'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
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

/// Bottom sheet showing locations
class LocationsSheet extends StatelessWidget {
  LocationsSheet({Key? key}) : super(key: key);
  final ServiceController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Obx(() {
        if (ctrl.locations.isEmpty) {
          return Column(
            children: [
              Container(height: 6, width: 40, color: Colors.grey[300]),
              SizedBox(height: 12),
              Text('Locations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Expanded(child: Center(child: Text('No locations found for this service.'))),
            ],
          );
        }

        return Column(
          children: [
            Container(height: 6, width: 40, color: Colors.grey[300]),
            SizedBox(height: 12),
            Text('Locations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: ctrl.locations.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, i) {
                  final l = ctrl.locations[i];
                  return ListTile(
                    leading: Icon(Icons.place, color: Colors.green.shade700),
                    title: Text(l.name),
                    subtitle: Text(l.address),
                    onTap: () {
                      // Could open maps using url_launcher (not included here)
                      Get.snackbar('Location selected', l.name);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

/// Comments (discussion) page
class CommentsPage extends StatelessWidget {
  CommentsPage({Key? key}) : super(key: key);

  final ServiceController ctrl = Get.find();
  final TextEditingController textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final svc = ctrl.selectedService.value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion — ${svc?.serviceName ?? ''}', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (ctrl.isCommentsLoading.value) return Center(child: CircularProgressIndicator());
              if (ctrl.comments.isEmpty) return Center(child: Text('No comments yet. Be the first!'));
              return ListView.separated(
                padding: EdgeInsets.all(12),
                separatorBuilder: (_, __) => Divider(),
                itemCount: ctrl.comments.length,
                itemBuilder: (context, i) {
                  final c = ctrl.comments[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(c.content.isNotEmpty ? c.content[0].toUpperCase() : '?')),
                    title: Text(c.content),
                    subtitle: Text(c.createdAt != null ? c.createdAt!.toLocal().toString() : ''),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12, bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textCtrl,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final text = textCtrl.text.trim();
                    if (text.isEmpty) return;
                    await ctrl.addComment(text);
                    textCtrl.clear();
                    Get.snackbar('Comment added', 'Your comment was posted.');
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
