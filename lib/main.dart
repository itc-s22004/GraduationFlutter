import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/login/login_validate.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:omg/mbti/mbti.dart';
import 'package:omg/registration/create_account.dart';

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
  Get.put(AuthController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

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
      // home: const LoginValidate(),
      home: const CreateAccountPage(),
      // home: ButtonScrollExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}
