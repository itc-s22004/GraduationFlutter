import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/login/loginNext.dart';
import 'package:omg/mbti/mbti.dart';
import 'package:omg/with/with.dart';

import '../comp/tag.dart';

class AddInfo extends StatefulWidget {
  final String data; // emailを保持
  const AddInfo({super.key, required this.data});

  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
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

          FirebaseFirestore.instance.collection('users').doc(docId).update({
            'gender': _genderController.text.trim(),
            'school': _schoolController.text.trim(),
            'diagnosis': _diagnosisController.text.trim(),
          });

          // AuthControllerに情報を反映
          authController.updateGender(_genderController.text.trim());
          authController.updateSchool(_schoolController.text.trim());
          authController.updateDiagnosis(_diagnosisController.text.trim());
        }
      });
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
            const SizedBox(height: 16), // スペースを追加
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => Mbti(data: widget.data)),
                  MaterialPageRoute(builder: (context) => Tag(email: widget.data,)),

                );
              },
              child: const Text('MBTIへ進む'),
            ),
          ],
        ),
      ),
    );
  }
}