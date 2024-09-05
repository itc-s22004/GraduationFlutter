import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SlideDirection {
  Left,
  Right,
  Up,
}

class StackedCard extends ChangeNotifier {
  final List<String> photos;
  final String title;
  final String subTitle;
  final String key;  // key プロパティの型を String に変更

  SlideDirection? direction;

  StackedCard({
    required this.photos,
    required this.title,
    required this.subTitle,
    required this.key,  // コンストラクタに String 型の key を追加
  });

  void slideLeft() {
    direction = SlideDirection.Left;
    notifyListeners();
  }

  void slideRight() {
    direction = SlideDirection.Right;
    notifyListeners();
  }

  void slideUp() {
    direction = SlideDirection.Up;
    notifyListeners();
  }
}



/// カードがスワイプされる際の方向を定義しておきます。
// enum SlideDirection {
//   Left,
//   Right,
//   Up,
// }
//
// class StackedCard extends ChangeNotifier {
//   final List<String> photos;
//   final String title;
//   final String? subTitle;
//
//   SlideDirection? direction;
//
//   StackedCard({
//     required this.photos,
//     required this.title,
//     this.subTitle, required String content,
//   });
//
//   void slideLeft() {
//     direction = SlideDirection.Left;
//     notifyListeners();
//   }
//
//   void slideRight() {
//     direction = SlideDirection.Right;
//     notifyListeners();
//   }
//
//   void slideUp() {
//     direction = SlideDirection.Up;
//     notifyListeners();
//   }
// }
