import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/comp/tag.dart';

class AddInfo extends StatefulWidget {
  final String data;
  const AddInfo({super.key, required this.data});

  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  String? _selectedGender;
  String? _selectedSchool;
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    _diagnosisController.dispose();
    _introductionController.dispose();
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
            'gender': _selectedGender,
            'school': _selectedSchool,
            'diagnosis': _diagnosisController.text.trim(),
          });

          authController.updateGender(_selectedGender ?? '');
          authController.updateSchool(_selectedSchool ?? '');
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
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ['男性', '女性', 'その他'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: '性別',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSchool,
              items: ['ITカレッジ', '外語学院'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSchool = newValue;
                });
              },
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tag(email: widget.data)),
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