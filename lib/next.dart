import 'package:flutter/material.dart';

class Next extends StatelessWidget {
  const Next({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('result2'),
            ],
          )
      ),
    );
  }
}

