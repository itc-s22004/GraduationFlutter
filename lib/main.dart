import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:omg/page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: GetMaterialApp(
        title: "omg",
        home: Home(),
        initialRoute: "/",
      ),
    ),
  );
}