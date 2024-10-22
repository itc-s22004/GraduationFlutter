import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/login/login_validate.dart';

import 'package:firebase_core/firebase_core.dart';

import 'auth_controller.dart';
import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // .env　ロード
//   // await dotenv.load(fileName: ".env");
//
//   await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform
//   );
//
//   runApp(
//     const ProviderScope(
//       child: GetMaterialApp(
//         title: "omg",
//         home: LoginValidate(),
//         initialRoute: "/",
//       ),
//     ),
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(), // MyAppを呼び出す
    ),
  );
}

// メインアプリウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "omg",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginValidate(), // ログイン画面をホームに設定
      debugShowCheckedModeBanner: false,
    );
  }
}
