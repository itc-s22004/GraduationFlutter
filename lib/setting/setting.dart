import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'editProf.dart';

class SettingScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('プロフィール'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/flutter.png"),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              authController.email.value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[300]),

            Obx(() => _buildProfileItem(Icons.person, '性別', authController.gender.value)),
            Obx(() => _buildProfileItem(Icons.school, '学校', authController.school.value)),
            Obx(() => _buildProfileItem(Icons.book, '診断', authController.diagnosis.value)),

            Obx(() => _buildTagsSection(authController.tags)),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
                side: const BorderSide(color: Colors.green),
              ),
              onPressed: () {
                Get.to(() => EditProfileScreen());
              },
              child: const Text('編集'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Text(
            '$label:',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'タグ:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: tags.map((tag) => Chip(
            label: Text(tag),
          )).toList(),
        ),
      ],
    );
  }
}