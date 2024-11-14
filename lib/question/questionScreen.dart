import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../auth_controller.dart';

class QuestionScreen extends StatelessWidget {
  // const QuestionScreen({super.key});
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('question一覧'),
      ),
      body: const Center(
        child: Text('Question画面', style: TextStyle(fontSize: 32.0)),
      ),
    );
  }
}