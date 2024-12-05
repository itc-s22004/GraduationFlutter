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
  try {
    print("try");
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e);
  }
  // await dotenv.load();
  print('環境変数読み込み完了');

  // 環境変数の読み込み確認用
  //print('API_KEY: ${dotenv.env['API_KEY']}');
  //print('APP_ID: ${dotenv.env['APP_ID']}');
  // print('MESSAGING_SENDER_ID: ${dotenv.env['MESSAGING_SENDER_ID']}');
  // print('PROJECT_ID: ${dotenv.env['PROJECT_ID']}');
  // print('AUTH_DOMAIN: ${dotenv.env['AUTH_DOMAIN']}');
  // print('STORAGE_BUCKET: ${dotenv.env['STORAGE_BUCKET']}');
  // print('MEASUREMENT_ID: ${dotenv.env['MEASUREMENT_ID']}');


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase 初期化完了');

  Get.put(AuthController());
  print('AuthController 初期化完了');

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