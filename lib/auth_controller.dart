import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  RxString email = ''.obs;
  RxInt userId = 0.obs;

  void updateEmail(String newEmail) {
    email.value = newEmail;
  }

  void updateUserId(int newUserId) {
    userId.value = newUserId;
  }

  Future<void> saveUserInfo(String userEmail, int userId) async {
    updateEmail(userEmail);
    updateUserId(userId);

    await FirebaseFirestore.instance.collection('users').doc(userEmail).set({
      'email': userEmail,
      'userId': userId,
    });
  }
}
