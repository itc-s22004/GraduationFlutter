import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
              Text('result'),
              ElevatedButton(onPressed: _toNext, child:Text("HomePage")),
            ],
          )
      ),
    );
  }
  void _toNext() {
    Get.to(() => const Next());
  }
}