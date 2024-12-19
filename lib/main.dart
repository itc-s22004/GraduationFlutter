// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:http/http.dart' as http; // httpパッケージをインポート
// import 'dart:convert';  // JSONをデコードするため
//
// import 'auth_controller.dart';
// import 'login/login_validate.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // dotenvのロード
//   // await dotenv.load();
//
//   // VercelのAPIからFirebase設定を取得
//   // const apiUrl = 'https://your-vercel-app-url/api/firebase-config';  // VercelのAPIエンドポイント
//   const apiUrl = 'https://omg2-six.vercel.app/api/firebase-config';  // Vercelのデプロイ先URL
//   final response = await http.get(Uri.parse(apiUrl));
//
//   if (response.statusCode == 200) {
//     // レスポンスが成功した場合、Firebaseの設定を取得
//     final Map<String, dynamic> firebaseConfig = json.decode(response.body);
//
//     // Firebaseの設定を使ってFirebaseを初期化
//     await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: firebaseConfig['apiKey'],
//         appId: firebaseConfig['appId'],
//         storageBucket: firebaseConfig['storageBucket'],
//         messagingSenderId: firebaseConfig['messagingSenderId'],
//         projectId: firebaseConfig['projectId'],
//         authDomain: firebaseConfig['authDomain'],
//         measurementId: firebaseConfig['measurementId'],
//       ),
//     );
//     print('Firebase 初期化完了');
//   } else {
//     print('Firebase設定の取得に失敗しました');
//   }
//
//   // AuthControllerの初期化
//   Get.put(AuthController());
//   print('AuthController 初期化完了');
//
//   // アプリケーションの実行
//   runApp(const ProviderScope(child: MyApp()));
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

// ------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth_controller.dart';
// import 'firebase_options.dart';
// import 'login/login_validate.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load();
//   // try {
//   //   print("try");
//   //   // await dotenv.load(fileName: ".env");
//   //   await Firebase.initializeApp(
//   //     options: DefaultFirebaseOptions.currentPlatform,
//   //   );
//   // } catch (e) {`
//     // Vercelで設定した環境変数を取得
//     // const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
//     // const appId = String.fromEnvironment('APP_ID', defaultValue: '');
//     // const storageBucket = String.fromEnvironment('STORAGE_BUCKET', defaultValue: '');
//     // const messagingSenderId = String.fromEnvironment('MESSAGING_SENDER_ID', defaultValue: '');
//     // const projectId = String.fromEnvironment('PROJECT_ID', defaultValue: '');
//     // const authDomain = String.fromEnvironment('AUTH_DOMAIN', defaultValue: '');
//     // const measurementId = String.fromEnvironment('MEASUREMENT_ID', defaultValue: '');
//     const apiKey = String.fromEnvironment('api_key', defaultValue: '');
//     const appId = String.fromEnvironment('app_id', defaultValue: '');
//     const storageBucket = String.fromEnvironment('storage_bucket', defaultValue: '');
//     const messagingSenderId = String.fromEnvironment('messaging_sender_id', defaultValue: '');
//     const projectId = String.fromEnvironment('project_id', defaultValue: '');
//     const authDomain = String.fromEnvironment('auth_domain', defaultValue: '');
//     const measurementId = String.fromEnvironment('measurement_id', defaultValue: '');
//
//     await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: apiKey,
//       appId: appId,
//       storageBucket: storageBucket,
//       messagingSenderId: messagingSenderId,
//       projectId: projectId,
//       authDomain: authDomain,
//       measurementId: measurementId),
//     );
//     print('Firebase 初期化完了');
//   // }
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

// ----------------------------------------------

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Vercelで設定した環境変数を取得
//   const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
//   const appId = String.fromEnvironment('APP_ID', defaultValue: '');
//   const storageBucket = String.fromEnvironment('STORAGE_BUCKET', defaultValue: '');
//   const messagingSenderId = String.fromEnvironment('MESSAGING_SENDER_ID', defaultValue: '');
//   const projectId = String.fromEnvironment('PROJECT_ID', defaultValue: '');
//   const authDomain = String.fromEnvironment('AUTH_DOMAIN', defaultValue: '');
//   const measurementId = String.fromEnvironment('MEASUREMENT_ID', defaultValue: '');
//
//   print('API_KEY: $apiKey');
//   print('PROJECT_ID: $projectId');
//   print('STORAGE_BUCKET: $storageBucket');
//
//   // Firebaseの初期化
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//         apiKey: apiKey,
//         appId: appId,
//         storageBucket: storageBucket,
//         messagingSenderId: messagingSenderId,
//         projectId: projectId,
//         authDomain: authDomain,
//         measurementId: measurementId),
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

// -----------------------------------------------------
// // 上がった
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_controller.dart';
import 'firebase_options.dart';
import 'login/login_validate.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .envが正しく設定されているか
  // try {
  //   print("try");
  //   await dotenv.load(fileName: ".env");
  // } catch (e) {
  //   print(e);
  // }
  // await dotenv.load(fileName: ".env");

  // print('環境変数読み込み完了');

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
      // home: const Mbti(data: 'test@a.com', fromEditProf: false),
      debugShowCheckedModeBanner: false,
    );
  }
}
