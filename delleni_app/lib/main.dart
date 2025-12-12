import 'package:delleni_app/app/modules/home/controllers/home_controller.dart';
import 'package:delleni_app/app/modules/home/controllers/service_controller.dart';
import 'package:delleni_app/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:delleni_app/app/modules/auth/views/login_view.dart';
import 'package:delleni_app/app/data/models/user_progress_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ServiceController()); // <-- ADD THIS
  Get.put(HomeController());

  // 1. Initialize Hive with Flutter
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserProgressModelAdapter());

  // 2. Initialize Supabase FIRST
  const supabaseUrl = 'https://zfrllrwqndzgfwbtnokl.supabase.co';
  const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmcmxscndxbmR6Z2Z3YnRub2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMDg3MjgsImV4cCI6MjA3OTY4NDcyOH0.gXvK2t3X_bUtd9EU9NjViSxcu6Whab5jq1lGUvus3sU';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(DelleniApp());
}

class DelleniApp extends StatelessWidget {
  DelleniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "دليلي",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green.shade700,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: HomeView(),
      // Initialize controllers lazily when needed
    );
  }
}
