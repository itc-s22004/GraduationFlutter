import 'package:flutter/cupertino.dart';

import '../swipe/stacked_card.dart';
import '../swipe/stacked_card_set.dart';
import '../swipe/stacked_card_view_item.dart';

// class StackedCardView extends StatefulWidget {
//   final StackedCardSet cardSet;
//
//   StackedCardView({required this.cardSet});
//
//   @override
//   _StackedCardViewState createState() => _StackedCardViewState();
// }
//
// class _StackedCardViewState extends State<StackedCardView> {
//   int currentIndex = 0;
//
//   void onSlideComplete(SlideDirection direction) {
//     setState(() {
//       if (currentIndex < widget.cardSet.cards.length - 1) {
//         currentIndex++;
//       } else {
//         currentIndex = 0; // すべてのカードがスワイプされたら最初に戻る
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StackedCardViewItem(
//       key: ValueKey(currentIndex), // 現在のインデックスに基づくKeyを設定
//       card: widget.cardSet.cards[currentIndex], // 現在のカードを設定
//       isDraggable: true, // ドラッグ可能にする
//       onSlideComplete: onSlideComplete, // スライド完了時のコールバックを設定
//       onSlideUpdate: (distance) {}, // スライド中の更新時の処理
//       scale: 1.0, itemData: '', // 必要に応じてスケールを設定
//     );
//   }
//
// }

class StackedCardView extends StatefulWidget
{
  final StackedCardSet cardSet;

  StackedCardView({
    required this.cardSet,
  });

  @override
  _StackedCardViewState createState() => _StackedCardViewState();
}

class _StackedCardViewState extends State<StackedCardView>
{
  /// 後ろに描写されるカードのスケールを操作するための変数
  double _nextCardScale = 0.0;

  late Key _frontItemKey;

  @override
  void initState()
  {
    super.initState();

    _setItemKey();
  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: <Widget>[
        Expanded(
          child: getChild(),
        )
      ],
    );
  }

  /// 先頭カードのWidgetに設定するキーを更新します
  void _setItemKey()
  {
    _frontItemKey = Key(widget.cardSet.getKey());
  }

  /// 先頭のカードがスワイプされた際、移動距離に応じてバックに配置されているカードのスケールを変更します
  void _onSlideUpdate(double distance)
  {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  /// スワイプ操作が完了した際に呼び出されます
  void _onSlideComplete(SlideDirection direction)
  {
    // TODO: アクションに応じて適宜実装
    switch (direction) {
      case SlideDirection.Left:
      // nope
        break;
      case SlideDirection.Right:
      // like
        break;
      case SlideDirection.Up:
      // super like
        break;
    }

    /// カードのインデックスを次の番号へ変更
    /// 確実に再レンダリングさせるため`Key`を更新して状態変更を通知
    setState(() {
      widget.cardSet.incrementCardIndex();
      _setItemKey();
    });
  }

  /// 後ろのカード（2枚目）を生成します
  /// 後ろのカードはドラッグが出来ないように制御します
  Widget _buildBackItem()
  {
    return StackedCardViewItem(
        isDraggable: false,
        card: widget.cardSet.getNextCard(),
        scale: _nextCardScale, key: ValueKey('backItem'), itemData: '', onSlideUpdate: (double ) {  }, onSlideComplete: (SlideDirection ) {  },
    );
  }

  /// 先頭のカード（1枚目）を生成します
  /// Widgetが再レンダリングされる際に確実に更新されるよう、`key`を渡します
  Widget _buildFrontItem()
  {
    return StackedCardViewItem(
      key: _frontItemKey,
      onSlideUpdate: _onSlideUpdate,
      onSlideComplete: _onSlideComplete,
      card: widget.cardSet.getFirstCard(), itemData: '', isDraggable: true, scale: 1.0,
    );
  }

  /// 先頭のカード（1枚目）とその背後のカード（2枚目）を生成します
  Widget getChild()
  {
    return Stack(
      children: <Widget>[
        _buildBackItem(),
        _buildFrontItem(),
      ],
    );
  }
}