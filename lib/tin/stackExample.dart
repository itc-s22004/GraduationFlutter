import 'package:flutter/material.dart';

class StackExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Stack Example')),
        body: Stack(
          children: [
            Center(child: Container(width: 300, height: 300, color: Colors.blue)),
            Positioned(
              top: 50.0,
              left: 50.0,
              child: Container(
                width: 100.0,
                height: 100.0,
                color: Colors.red,
                child: Center(child: Text('Overlay', style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(StackExample());
