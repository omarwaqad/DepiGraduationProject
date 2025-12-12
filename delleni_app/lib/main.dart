// lib/main.dart - Updated
import 'package:delleni_app/app/bindings/app_binding.dart';
import 'package:delleni_app/app/models/user_progress.dart';
import 'package:delleni_app/app/pages/login.dart';
import 'package:delleni_app/app/pages/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserProgressAdapter());

  const url = 'https://zfrllrwqndzgfwbtnokl.supabase.co';
  const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmcmxscndxbmR6Z2Z3YnRub2tsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQxMDg3MjgsImV4cCI6MjA3OTY4NDcyOH0.gXvK2t3X_bUtd9EU9NjViSxcu6Whab5jq1lGUvus3sU';

  await Supabase.initialize(url: url, anonKey: anonKey);

  // Ensure bindings are registered before runApp (belt-and-suspenders with initialBinding)
  AppBinding().dependencies();

  runApp(Delleni());
}

final global = Supabase.instance.client;

class Delleni extends StatelessWidget {
  Delleni({super.key});

  @override
  Widget build(BuildContext context) {
    final green = Colors.green.shade700;

    return GetMaterialApp(
      title: "Delleni",
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      theme: ThemeData(
        primaryColor: green,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: Login(),
      getPages: [
        GetPage(name: '/main', page: () => MainLayout()),
        // Add other routes as needed
      ],
    );
  }
}
