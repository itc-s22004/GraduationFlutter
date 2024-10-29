// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:omg/chat/chat.dart';
// import 'package:omg/login/login_validate.dart';
// import 'package:omg/registration/create_account.dart';
// import 'package:omg/with.dart';
// import 'next.dart';
//
// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('result1'),
//             ElevatedButton(
//               // onPressed: _toChat,
//               // onPressed: _toLogin,
//               onPressed: _toRegistration,
//               // onPressed: _toNext,
//               // onLongPress: _toWith,
//               // onPressed: _toWith,
//               child: const Text('Go to NextPage'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // void _toChat() {
//   //   Get.to(() => const ChatRoom());
//   // }
//
//   void _toRegistration() {
//     Get.to(() => const CreateAccountPage());
//   }
//
//   void _toLogin() {
//     Get.to(() => const LoginValidate());
//   }
//
//   void _toWith() {
//     // return const ProviderScope(child: MainApp());
//     Get.to(() => const MainApp());
//
//   }
//
//   void _toNext() {
//     Get.to(() => const Next());
//   }
// }