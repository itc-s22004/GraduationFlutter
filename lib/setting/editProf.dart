import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../mbti/mbti.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? _selectedGender;
  String? _selectedSchool;

  final AuthController authController = Get.find<AuthController>();

  final TextEditingController genderController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController introductionController = TextEditingController();

  final tags = [
    'ビール', 'ワイン', '日本酒', '焼酎', 'ウィスキー',
    'ジン', 'ウォッカ', '紹興酒', 'マッコリ', 'カクテル', '果実酒',
  ];
  List<String> selectedTags = [];

  Future<void> loadUserData() async {
    try {
      final email = authController.email.value ?? '';
      if (email != '') {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          genderController.text = data['gender'] ?? '';
          schoolController.text = data['school'] ?? '';
          diagnosisController.text = data['diagnosis'] ?? '';
          introductionController.text = data['introduction'] ?? '';
          selectedTags = List<String>.from(data['tag'] ?? []);
          setState(() {});
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  Future<void> saveUserData() async {
    try {
      final email = authController.email.value ?? '';
      if (email != '') {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((snapshot) => snapshot.docs.first.reference);

        await userRef.then((ref) => ref.update({
          'gender': _selectedGender,
          'school': _selectedSchool,
          'diagnosis': diagnosisController.text,
          'introduction': introductionController.text,
          'tag': selectedTags,
        }));

        authController.updateProfileData(
          newGender: genderController.text,
          newSchool: schoolController.text,
          newDiagnosis: diagnosisController.text,
          newIntroduction: introductionController.text,
          newTags: selectedTags,
        );

        Get.back();
      }
    } catch (e) {
      print("保存中にエラーが発生しました: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    genderController.dispose();
    schoolController.dispose();
    diagnosisController.dispose();
    introductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            // const SizedBox(height: 16),
            // TextField(
            //   controller: diagnosisController,
            //   decoration: const InputDecoration(labelText: '診断'),
            // ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mbti(data: authController.email.value, fromEditProf: true),
                  ),
                );
              },
              child: const Text('診断を受ける'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: introductionController,
              decoration: const InputDecoration(labelText: '自己紹介'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Wrap(
              runSpacing: 16,
              spacing: 16,
              children: tags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  onTap: () {
                    setState(() {
                      isSelected ? selectedTags.remove(tag) : selectedTags.add(tag);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      border: Border.all(width: 2, color: Colors.pink),
                      color: isSelected ? Colors.pink : null,
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTags.clear();
                    });
                  },
                  child: const Text('クリア'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedTags = List.of(tags);
                    });
                  },
                  child: const Text('すべて'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: saveUserData,
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}