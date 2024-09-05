import 'package:flutter/material.dart';
import 'package:omg/swipe/stacked_card.dart'; // StackedCard をインポート

class StackedCardViewItem extends StatelessWidget {
  final StackedCard card;
  final String itemData;
  final bool isDraggable;
  final double scale;
  final Function(double) onSlideUpdate;
  final Function(SlideDirection) onSlideComplete;

  StackedCardViewItem({
    required Key key,
    required this.card,
    required this.itemData,
    required this.isDraggable,
    required this.scale,
    required this.onSlideUpdate,
    required this.onSlideComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Card(
        child: Column(
          children: [
            // 写真をリストから表示
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: card.photos.length,
                itemBuilder: (context, index) {
                  return Image.asset(card.photos[index]); // 画像を表示
                },
              ),
            ),
            // タイトルとサブタイトルを表示
            ListTile(
              title: Text(card.title),
              subtitle: Text(card.subTitle),
            ),
          ],
        ),
      ),
    );
  }
}

