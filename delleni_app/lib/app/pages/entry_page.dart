import 'package:delleni_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final auth = Get.find<AuthController>();
              await auth.logout();
              Get.off(Login());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
