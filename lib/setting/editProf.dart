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

  // コントローラー
  final TextEditingController emailController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController introductionController = TextEditingController();

  // プルダウンメニューの選択肢
  final List<String> genderOptions = ['男性', '女性', 'その他'];
  final List<String> schoolOptions = ['ITカレッジ沖縄', '外語学院'];

  String? selectedGender;
  String? selectedSchool;

  @override
  void initState() {
    super.initState();
    // 初期データの読み込み
    loadUserData();
  }

  void loadUserData() {
    emailController.text = authController.email.value;
    diagnosisController.text = authController.diagnosis.value;
    introductionController.text = authController.introduction.value;

    // genderとschoolがそれぞれのリスト内に存在するか確認
    selectedGender = genderOptions.contains(authController.gender.value) ? authController.gender.value : null;
    selectedSchool = schoolOptions.contains(authController.school.value) ? authController.school.value : null;
  }

  Future<void> refreshDiagnosis() async {
    // AuthControllerの最新の診断結果でdiagnosisControllerを更新
    diagnosisController.text = authController.diagnosis.value;
  }

  void saveProfile() {
    // 入力したデータをAuthControllerに更新
    authController.updateGender(selectedGender ?? '');
    authController.updateSchool(selectedSchool ?? '');
    authController.updateDiagnosis(diagnosisController.text);
    authController.updateIntroduction(introductionController.text);

    // Firestoreに保存
    authController.saveUserData();
    Get.back(); // 前の画面に戻る
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
            ElevatedButton(
              onPressed: () async {
                // 診断ページに遷移
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Mbti(
                      data: authController.email.value,
                      fromEditProf: true,
                    ),
                  ),
                );

                // 診断結果をリフレッシュ
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
    // コントローラーのリソース解放
    emailController.dispose();
    diagnosisController.dispose();
    introductionController.dispose();
    super.dispose();
  }
}