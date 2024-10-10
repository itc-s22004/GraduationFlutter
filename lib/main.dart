import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/login/login_validate.dart';
import 'package:omg/next.dart';
import 'package:omg/page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omg/registration/create_account.dart';
import 'package:omg/with.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .env　ロード
  // await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    const ProviderScope(
      child: GetMaterialApp(
        title: "omg",
        // home: Home(),
        // home: Next(),
        home: LoginValidate(),
        // home: CreateAccountPage(),
        // home: MainApp(),
        initialRoute: "/",
      ),
    ),
  );
}