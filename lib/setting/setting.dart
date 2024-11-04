import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class SettingScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final email = authController.email.value ?? '';
      if (email != '') {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.data();
        }
      }
      return null;
    } catch (e) {
      print("エラーが発生しました: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Setting'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('ユーザー情報が見つかりません'));
          }

          final userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${userData['email']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Gender: ${userData['gender']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('School: ${userData['school']}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Diagnosis: ${userData['diagnosis']}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
