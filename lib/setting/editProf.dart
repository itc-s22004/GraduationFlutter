import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../comp/tag.dart';
import '../mbti/mbti.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final authController = Get.find<AuthController>();
  bool isFocused = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController introductionController = TextEditingController();

  final FocusNode introductionFocusNode = FocusNode();

  final List<String> genderOptions = ['男性', '女性', 'その他'];
  final List<String> schoolOptions = ['ITカレッジ沖縄', '外語学院'];

  String? selectedGender;
  String? selectedSchool;
  var selectedTags = <String>[];

  @override
  void initState() {
    super.initState();
    loadUserData();

    introductionFocusNode.addListener(() {
      setState(() {
        isFocused = introductionFocusNode.hasFocus;
      });
    });
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

  void updateTags() {
    setState(() {
      selectedTags = authController.tags.value;
    });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'メールアドレス',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                filled: true,
                fillColor: Colors.blueGrey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['男性', '女性', 'その他'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: '性別',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                filled: true,
                fillColor: Colors.blueGrey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSchool,
              items: ['ITカレッジ沖縄', '外語学院',].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSchool = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: '学校',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                filled: true,
                fillColor: Colors.blueGrey.shade50,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mbti(
                      data: authController.email.value,
                      fromEditProf: true),
                  ),
                );
                refreshDiagnosis();
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: diagnosisController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'MBTI',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    filled: true,
                    fillColor: Colors.blueGrey.shade50,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              focusNode: introductionFocusNode,
              minLines: 1,
              maxLines: null,
              controller: introductionController,
              decoration: InputDecoration(
                // labelText: 'labelText',
                labelText: isFocused ? '自己紹介' : '素敵な自己紹介を書いてね！！！',
                labelStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                floatingLabelAlignment: FloatingLabelAlignment.center,
                filled: true,
                fillColor: Colors.blueGrey.shade50,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tag(
                        email: authController.email.value,
                        fromEditProf: true)
                    )
                );
                setState(() {
                  selectedTags = authController.tags.value;
                });
              },
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'タグを編集する',
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      filled: true,
                      fillColor: Colors.blueGrey.shade50
                  ),
                ),
              ),
            ),
            selectedTags.isNotEmpty
                ? Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: selectedTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue,
                );
              }).toList(),
            )
                : const Text('タグが選択されていません'),
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