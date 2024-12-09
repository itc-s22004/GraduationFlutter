// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../auth_controller.dart';
//
// class LoginNext extends StatelessWidget {
//   const LoginNext({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.find<AuthController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ユーザー情報'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ElevatedButton(
//           onPressed: () {
//             SlideInText(text: 'text',);
//             print('ボタンが押されました');
//           },
//           child: const Text('スワイプ処理開始'),
//         ),
//       ),
//
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_3d/text_3d.dart';
import '../auth_controller.dart';

class LoginNext extends StatefulWidget {
  const LoginNext({super.key});

  @override
  _LoginNextState createState() => _LoginNextState();
}

class _LoginNextState extends State<LoginNext> {
  bool _showSlideText = false; // 追加: アニメーションの表示状態

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showSlideText = false; // 既存のアニメーションをリセット
                });

                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    _showSlideText = true; // アニメーションを再表示
                  });

                  Future.delayed(const Duration(seconds: 3), () {
                    setState(() {
                      _showSlideText = false; // 2秒後にテキストを非表示に
                    });
                  });
                });

                print('ボタンが押されました');
              },
              child: const Text('スワイプ処理開始'),
            ),
            if (_showSlideText) SlideInText(), // アニメーションを表示する
          ],
        ),
      ),
    );
  }
}

class SlideInText extends StatefulWidget {
  final Duration duration;

  SlideInText({this.duration = const Duration(seconds: 1)});

  @override
  _SlideInTextState createState() => _SlideInTextState();
}

class _SlideInTextState extends State<SlideInText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    print('SlideInText: initState called'); // ログ出力

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(8.0, 0.0), // 右外（画面外）からスタート
      end: Offset.zero, // 中央に移動
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    print('SlideInText: dispose called'); // dispose呼ばれた時のログ
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('SlideInText: build called'); // buildが呼ばれるたびにログを出力

    return Stack(
      children: [
        // 背景にグラデーションの黒い霧を追加
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black26,
                Colors.black87,
                Colors.black87,
                Colors.black26,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.1, 0.9, 1.0],
            ),
          ),
        ),
        Center(
          child: SlideTransition(
            position: _animation,
            child: ThreeDText(
              text: 'HATTEN',
              textStyle: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              depth: 6,  // 立体感の深さ
              style: ThreeDStyle.perspectiveLeft,  // 立体感のスタイル（視点の設定）
              perspectiveDepth: -70.0,  // 視点の深さ
            ),
          ),
        ),
      ],
    );
  }
}
