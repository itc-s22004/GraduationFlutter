import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/login/loginNext.dart';
import 'package:omg/with.dart';

class Diagnosis extends StatefulWidget {
  final String data; // emailを保持
  const Diagnosis({super.key, required this.data});

  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _genderController.dispose();
    _schoolController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.data)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          String docId = userDoc.id;
          String email = userDoc['email'];
          int userId = userDoc['id'];

          authController.saveUserInfo(email, userId);

          FirebaseFirestore.instance.collection('users').doc(docId).update({
            'gender': _genderController.text.trim(),
            'school': _schoolController.text.trim(),
            'diagnosis': _diagnosisController.text.trim(),
          });
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザー情報が更新されました')),
      );

      Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const LoginNext()),
        MaterialPageRoute(builder: (context) => const MainApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('エラーが発生しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('追加情報入力'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('email: ${widget.data}'),
            const SizedBox(height: 16),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(
                labelText: '性別',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _schoolController,
              decoration: const InputDecoration(
                labelText: '学校',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: '診断結果',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateUserData,
              child: const Text('情報を更新'),
            ),
          ],
        ),
      ),
    );
  }
}