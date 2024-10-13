import 'package:get/get.dart';

class AuthController extends GetxController {
  var email = ''.obs; // Emailを保持するRx
  var userId = 0.obs; // userIdを保持するRx

  // Emailの値を更新
  void updateEmail(String newEmail) {
    email.value = newEmail;
  }

  // userIdの値を更新
  void updateUserId(int newUserId) {
    userId.value = newUserId;
  }
}
