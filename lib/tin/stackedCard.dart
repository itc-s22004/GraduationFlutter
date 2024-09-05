import 'package:flutter/cupertino.dart';

/// カードがスワイプされる際の方向を定義しておきます。
enum SlideDirection {
  Left,
  Right,
  Up,
}

class StackedCard extends ChangeNotifier
{
  final List<String> photos;
  final String title;
  final String subTitle;

  late SlideDirection direction;

  StackedCard({
    required this.photos,
    required this.title,
    required this.subTitle,
  });

  void slideLeft()
  {
    direction = SlideDirection.Left;
    notifyListeners();
  }

  void slideRight()
  {
    direction = SlideDirection.Right;
    notifyListeners();
  }

  void slideUp()
  {
    direction = SlideDirection.Up;
    notifyListeners();
  }
}