import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxString email = ''.obs;
  RxInt userId = 0.obs;
  RxString gender = ''.obs;
  RxString school = ''.obs;
  RxString diagnosis = ''.obs;
  RxList<String> tags = <String>[].obs;

  void updateEmail(String newEmail) {
    email.value = newEmail;
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

  void updateTags(List<String> value) {
    tags.value = value;
  }

  void updateProfileData({
    required String newGender,
    required String newSchool,
    required String newDiagnosis,
    required List<String> newTags,
  }) {
    gender.value = newGender;
    school.value = newSchool;
    diagnosis.value = newDiagnosis;
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
          tags.assignAll(List<String>.from(data['tags'] ?? []));
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }
}