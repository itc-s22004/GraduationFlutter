import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omg/page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( const GetMaterialApp(
    title: "omg",
    home:  Home(),
    initialRoute: "/",
  ));

}
