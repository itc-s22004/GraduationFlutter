import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_controller.dart';
import 'firebase_options.dart';
import 'login/login_validate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .envが正しく設定されているか
  await dotenv.load(fileName: "../lib/../.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());

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
      home: const LoginValidate(),
      // home: const AddInfo(data: "test@a.com"),
      debugShowCheckedModeBanner: false,
    );
  }
}
