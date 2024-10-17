import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class LoginNext extends StatelessWidget {
  const LoginNext({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthControllerのインスタンスを取得
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // メールアドレスを表示
            Obx(() => Text('メールアドレス: ${authController.email.value}')),
            const SizedBox(height: 20),
            // ユーザーIDを表示
            Obx(() => Text('ユーザーID: ${authController.userId.value}')),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
//
// class LoginNext extends StatelessWidget {
//   const LoginNext({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('next page'),
//             ],
//           )
//       ),
//     );
//   }
// }
//
