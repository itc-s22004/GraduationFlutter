import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/login/login_validate.dart';
import 'package:omg/page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omg/registration/create_account.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    const ProviderScope(
      child: GetMaterialApp(
        title: "omg",
        // home: Home(),
        home: LoginValidate(),
        // home: CreateAccountPage(),
        initialRoute: "/",
      ),
    ),
  );
}