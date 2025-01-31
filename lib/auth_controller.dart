import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString email = ''.obs;
  RxInt userId = 0.obs;
  RxString gender = ''.obs;
  RxString school = ''.obs;
  RxString schoolNum = ''.obs;
  RxString diagnosis = ''.obs;
  RxString introduction = ''.obs;
  RxList<String> tags = <String>[].obs;
  RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;
  RxInt swipedUserId = 0.obs;

  void updateEmail(String newEmail) {
    email.value = newEmail;
  }

  void updateSchoolNum(String value) {
    schoolNum.value = value;
  }

  void updateUserId(int newUserId) {
    userId.value = newUserId;
  }

  void updateGender(String value) {
    gender.value = value;
  }

  void updateSchool(String value) {
    school.value = value;
  }

  void updateDiagnosis(String value) {
    diagnosis.value = value;
  }

  void updateIntroduction(String value) {
    introduction.value = value;
  }

  void updateTags(List<String> value) {
    tags.value = value;
  }

  void updateProfileData({
    required String newGender,
    required String newSchool,
    required String newDiagnosis,
    required String newIntroduction,
    required List<String> newTags,
  }) {
    gender.value = newGender;
    school.value = newSchool;
    diagnosis.value = newDiagnosis;
    introduction.value = newIntroduction;
    tags.assignAll(newTags);
  }

  Future<void> fetchUserData() async {
    try {
      if (email.value.isNotEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.value)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          gender.value = data['gender'] ?? '';
          school.value = data['school'] ?? '';
          diagnosis.value = data['diagnosis'] ?? '';
          introduction.value = data['introduction'] ?? '';
          tags.assignAll(List<String>.from(data['tag'] ?? []));
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  Future<void> fetchQuestions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .get();

      // 質問データを取得して保持
      questions.assignAll(snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList());
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }


  Future<void> saveUserData() async {
    try {
      if (email.value.isNotEmpty) {
        // ユーザーのドキュメントを検索し、既存ドキュメントを更新
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.value)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // ドキュメントIDを取得して更新処理を実行
          final docId = snapshot.docs.first.id;
          await FirebaseFirestore.instance.collection('users').doc(docId).update({
            'gender': gender.value,
            'school': school.value,
            'diagnosis': diagnosis.value,
            'introduction': introduction.value,
            'tag': tags,
          });
          print("User data saved successfully.");
        } else {
          print("User document not found.");
        }
      }
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }
}