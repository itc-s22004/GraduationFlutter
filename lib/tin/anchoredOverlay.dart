import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Alignment anchor;
  final Widget Function(BuildContext context) overlayBuilder;
  final Widget? child;

  const AnchoredOverlay({
    Key? key,
    required this.showOverlay,
    required this.anchor,
    required this.overlayBuilder,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!, // 元のウィジェットを表示
        if (showOverlay)
          Positioned.fill(
            child: Align(
              alignment: anchor,
              child: overlayBuilder(context), // オーバーレイを表示
            ),
          ),
      ],
    );
  }
}
