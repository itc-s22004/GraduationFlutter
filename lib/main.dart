// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth_controller.dart';
// import 'firebase_options.dart';
// import 'login/login_validate.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // .envが正しく設定されているか
//   await dotenv.load(fileName: ".env");
//   // await dotenv.load();
//   print('環境変数読み込み完了');
//
//   // 環境変数の読み込み確認用
//   // print('環境変数読み込み完了');
//   // print('API_KEY: ${dotenv.env['API_KEY']}');
//   // print('APP_ID: ${dotenv.env['APP_ID']}');
//   // print('MESSAGING_SENDER_ID: ${dotenv.env['MESSAGING_SENDER_ID']}');
//   // print('PROJECT_ID: ${dotenv.env['PROJECT_ID']}');
//   // print('AUTH_DOMAIN: ${dotenv.env['AUTH_DOMAIN']}');
//   // print('STORAGE_BUCKET: ${dotenv.env['STORAGE_BUCKET']}');
//   // print('MEASUREMENT_ID: ${dotenv.env['MEASUREMENT_ID']}');
//
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   print('Firebase 初期化完了');
//
//   Get.put(AuthController());
//   print('AuthController 初期化完了');
//
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "omg",
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const LoginValidate(),
//       // home: const AddInfo(data: "test@a.com"),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// -----------

// import 'dart:io'; // dart:io を使うのは Web 環境以外
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth_controller.dart';
// import 'firebase_options.dart';
// import 'login/login_validate.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // .env ファイルの読み込み（Web 環境以外のみ）
//   const isWeb = identical(0, 0.0);
//   if (!isWeb) {
//     try {
//       if (await File('.env').exists()) {
//         await dotenv.load(fileName: ".env");
//         print('環境変数読み込み完了');
//       } else {
//         print('.env ファイルが存在しません。スキップします。');
//       }
//     } catch (e) {
//       print('.env ファイルの読み込みエラー: $e');
//     }
//   } else {
//     print('Web 環境では dotenv をスキップします。');
//   }
//
//   // Firebase 初期化
//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     print('Firebase 初期化完了');
//   } catch (e) {
//     print('Firebase 初期化エラー: $e');
//   }
//
//   // AuthController 初期化
//   Get.put(AuthController());
//   print('AuthController 初期化完了');
//
//   // アプリの起動
//   runApp(
//     const ProviderScope(
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: "omg",
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const LoginValidate(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
import 'dart:io'; // dart:io を使うのは Web 環境以外
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_controller.dart';
import 'firebase_options.dart'; // firebase_options.dartをインポート
import 'login/login_validate.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    try {
      if (await File('.env').exists()) {
        await dotenv.load(fileName: ".env");
        print('環境変数読み込み完了');
      } else {
        print('.env ファイルが存在しません。スキップします。');
      }
    } catch (e) {
      print('.env ファイルの読み込みエラー: $e');
    }
  } else {
    print('Web 環境では dotenv をスキップします。');
  }

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform, // Web用 Firebase オプション
      );
    } else {
      await Firebase.initializeApp();
    }
    print('Firebase 初期化完了');
  } catch (e) {
    print('Firebase 初期化エラー: $e');
  }

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
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> loginWithEmailPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('ログイン成功: ${userCredential.user?.email}');
  } on FirebaseAuthException catch (e) {
    print('ログインエラー: ${e.message}');
  } catch (e) {
    print('未知のエラー: $e');
  }
}
