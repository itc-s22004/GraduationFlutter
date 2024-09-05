import 'package:flutter/material.dart';
import 'package:omg/swipe/stacked_card.dart';
import 'package:omg/swipe/stacked_card_set.dart';
import 'package:omg/swipe/stacked_card_view_item.dart';

class StackedCardView extends StatefulWidget {
  final StackedCardSet cardSet;

  const StackedCardView({
    required this.cardSet,
  });

  @override
  _StackedCardViewState createState() => _StackedCardViewState();
}

class _StackedCardViewState extends State<StackedCardView> {
  double _nextCardScale = 0.0;
  late Key _frontItemKey;

  @override
  void initState() {
    super.initState();
    _setItemKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _buildBackItem(),
            _buildFrontItem(),
          ],
        ),
      ),
    );
  }

  void _setItemKey() {
    _frontItemKey = Key(widget.cardSet.getKey()?.toString() ?? 'default');
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideComplete(SlideDirection direction) {
    setState(() {
      widget.cardSet.incrementCardIndex();
      _setItemKey();
    });
  }

  Widget _buildBackItem() {
    final card = widget.cardSet.getNextCard();
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: StackedCardViewItem(
          key: ValueKey('back_${widget.cardSet.getKey()?.toString() ?? 'default'}'),
          card: card,
          itemData: '',
          isDraggable: false,
          scale: _nextCardScale,
          onSlideUpdate: (distance) {},
          onSlideComplete: (direction) {},
        ),
      ),
    );
  }

  Widget _buildFrontItem() {
    final card = widget.cardSet.getFirstCard();
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: StackedCardViewItem(
          key: _frontItemKey,
          card: card,
          itemData: '',
          isDraggable: true,
          scale: 1.0,
          onSlideUpdate: _onSlideUpdate,
          onSlideComplete: _onSlideComplete,
        ),
      ),
    );
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:omg/swipe/stacked_card.dart';
// import 'package:omg/swipe/stacked_card_set.dart';
// import 'package:omg/swipe/stacked_card_view_item.dart';
//
// class StackedCardView extends StatefulWidget {
//   // const StackedCardView({});
//   final StackedCardSet cardSet;
//
//   const StackedCardView({
//     required this.cardSet,
//   });
//
//   @override
//   _StackedCardViewState createState() => _StackedCardViewState();
// }
//
// class _StackedCardViewState extends State<StackedCardView> {
//   double _nextCardScale = 0.0;
//   late Key _frontItemKey;
//
//   @override
//   void initState() {
//     super.initState();
//     _setItemKey();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: getChild(),
//         )
//       ],
//     );
//   }
//
//   void _setItemKey() {
//     _frontItemKey = Key(widget.cardSet.getKey() as String);
//   }
//
//   void _onSlideUpdate(double distance) {
//     setState(() {
//       _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
//     });
//   }
//
//   void _onSlideComplete(SlideDirection direction) {
//     // TODO: アクションに応じて適宜実装
//     setState(() {
//       widget.cardSet.incrementCardIndex();
//       _setItemKey();
//     });
//   }
//
//
//   Widget _buildBackItem() {
//     return StackedCardViewItem(
//       // key: _frontItemKey, // keyはoptionalではなく、必須引数として指定されている
//       // onSlideUpdate: _onSlideUpdate, // onSlideUpdateはoptional
//       // onSlideComplete: _onSlideComplete, // onSlideCompleteはoptional
//       // card: widget.cardSet.getFirstCard(), // 必須引数
//       // itemData: '', // 必須引数（空の文字列を指定）
//       // isDraggable: true, // 必須引数（例としてtrueを指定）
//       // scale: 1.0, // 必須引数（例として1.0を指定）
//       key: ValueKey('back_${widget.cardSet.getKey()}'), // バックカード用のキー
//       card: widget.cardSet.getNextCard(), // バックカードのカード
//       itemData: '', // 必須引数
//       isDraggable: false, // バックカードはドラッグ不可
//       scale: _nextCardScale, // スケール
//       onSlideUpdate: (distance) {}, // バックカードには空の関数を指定
//       onSlideComplete: (direction) {}, // バックカードには空の関数を指定
//     );
//   }
//
//   Widget _buildFrontItem() {
//     return StackedCardViewItem(
//       // key: _frontItemKey,
//       // onSlideUpdate: _onSlideUpdate,
//       // onSlideComplete: _onSlideComplete,
//       // card: widget.cardSet.getFirstCard(), itemData: '',
//       key: _frontItemKey,
//       card: widget.cardSet.getFirstCard(), // フロントカードのカード
//       itemData: '', // 必須引数
//       isDraggable: true, // フロントカードはドラッグ可能
//       scale: 1.0, // スケール
//       onSlideUpdate: _onSlideUpdate, // スライド中の更新処理
//       onSlideComplete: _onSlideComplete, // スライド完了時の処理
//     );
//   }
//
//   Widget getChild() {
//     return Stack(
//       children: <Widget>[
//         _buildBackItem(),
//         _buildFrontItem(),
//       ],
//     );
//   }
// }
