import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../mbti/mbti.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final authController = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController introductionController = TextEditingController();

  final List<String> genderOptions = ['男性', '女性', 'その他'];
  final List<String> schoolOptions = ['ITカレッジ沖縄', '外語学院'];
  final List<String> tags = [
    'ビール', 'ワイン', '日本酒', '焼酎', 'ウィスキー',
    'ジン', 'ウォッカ', '紹興酒', 'マッコリ', 'カクテル', '果実酒',
  ];

  String? selectedGender;
  String? selectedSchool;
  var selectedTags = <String>[];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() {
    emailController.text = authController.email.value;
    diagnosisController.text = authController.diagnosis.value;
    introductionController.text = authController.introduction.value;
    selectedGender = authController.gender.value;
    selectedSchool = authController.school.value;
    selectedTags = authController.tags.value;
  }

  Future<void> refreshDiagnosis() async {
    diagnosisController.text = authController.diagnosis.value;
  }

  void saveProfile() {
    authController.updateGender(selectedGender ?? '');
    authController.updateSchool(selectedSchool ?? '');
    authController.updateDiagnosis(diagnosisController.text);
    authController.updateIntroduction(introductionController.text);
    authController.updateTags(selectedTags);

    authController.saveUserData();
    Get.back();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            DropdownButtonFormField<String>(
              value: selectedSchool,
              items: schoolOptions.map((String school) {
                return DropdownMenuItem<String>(
                  value: school,
                  child: Text(school),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSchool = value;
                });
              },
              decoration: const InputDecoration(labelText: 'School'),
            ),
            TextField(
              controller: diagnosisController,
              readOnly: true,
              decoration: const InputDecoration(labelText: '診断結果 (MBTI)'),
            ),
            TextField(
              controller: introductionController,
              decoration: const InputDecoration(labelText: '自己紹介'),
            ),
            const SizedBox(height: 20),

            // タグの選択
            const Text("タグを選択"),
            Wrap(
              spacing: 8.0,
              children: tags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      isSelected ? selectedTags.remove(tag) : selectedTags.add(tag);
                    });
                  },
                  selectedColor: Colors.pink,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // MBTI診断ボタン
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mbti(
                      data: authController.email.value,
                      fromEditProf: true,
                    ),
                  ),
                );
                refreshDiagnosis();
              },
              child: const Text('診断を受ける'),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfile,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    diagnosisController.dispose();
    introductionController.dispose();
    super.dispose();
  }
}