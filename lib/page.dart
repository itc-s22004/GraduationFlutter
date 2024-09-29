import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/with.dart';

import 'next.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('result1'),
            ElevatedButton(
              // onPressed: _toNext,
              onLongPress: _toWith,
              onPressed: _toWith,
              child: Text('Go to NextPage'),
            ),
          ],
        ),
      ),
    );
  }

  void _toWith() {
    // return const ProviderScope(child: MainApp());
    Get.to(() => const MainApp());

  }

  void _toNext() {
    Get.to(() => const Next());
  }
}