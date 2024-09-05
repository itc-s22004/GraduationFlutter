import 'package:flutter/material.dart';

class OverlayExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Overlay Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showOverlay(context);
            },
            child: Text('Show Overlay'),
          ),
        ),
      ),
    );
  }

  void showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100.0,
        left: 100.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.red,
            child: Center(child: Text('Overlay', style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Optionally, you can remove the overlay entry later
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

void main() => runApp(OverlayExample());
