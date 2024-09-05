import 'package:flutter/material.dart';
import 'package:omg/swipe/stacked_card.dart';

import 'stacked_card.dart';

class StackedCardSet {
  final List<StackedCard> _cards;
  int _currentIndex = 0;

  StackedCardSet({
    required List<StackedCard> cards,  // List<StackedCard> 型に修正
  }) : _cards = cards;

  StackedCard getFirstCard() {
    if (_cards.isEmpty) {
      throw RangeError('No cards available');
    }
    return _cards[0];
  }

  StackedCard getNextCard() {
    if (_cards.isEmpty || _currentIndex >= _cards.length - 1) {
      throw RangeError('No more cards');
    }
    return _cards[++_currentIndex];
  }

  String getKey() {
    if (_cards.isEmpty) {
      throw RangeError('No cards available');
    }
    return _cards[_currentIndex].key;
  }

  void incrementCardIndex() {
    if (_currentIndex < _cards.length - 1) {
      _currentIndex++;
    }
  }
}


// ------------------------------------------------------------

// import 'package:flutter/cupertino.dart';
// import 'package:omg/swipe/stacked_card.dart';
//
// class StackedCardSet {
//   final List<StackedCard> _cards;  // ここで Card の代わりに StackedCard を使用する
//   int _currentIndex = 0;
//
//   // コンストラクタの修正: 必須引数として _cards を受け取る
//   StackedCardSet(this._cards);
//
//   StackedCard getFirstCard() {
//     if (_cards.isEmpty) {
//       throw RangeError('No cards available');
//     }
//     return _cards[0];
//   }
//
//   StackedCard getNextCard() {
//     if (_cards.isEmpty || _currentIndex >= _cards.length - 1) {
//       throw RangeError('No more cards');
//     }
//     return _cards[++_currentIndex];
//   }
//
//   Key? getKey() {
//     if (_cards.isEmpty) {
//       throw RangeError('No cards available');
//     }
//     return _cards[_currentIndex].key;
//   }
//
//   void incrementCardIndex() {
//     if (_currentIndex < _cards.length - 1) {
//       _currentIndex++;
//     }
//   }
// }

// ------------------------------------------------------------
//
// class StackedCardSet {
//   final List<Card> _cards;
//   int _currentIndex = 0;
//
//   StackedCardSet(this._cards, {required List cards});
//
//
//   Card getFirstCard() {
//     if (_cards.isEmpty) {
//       throw RangeError('No cards available');
//     }
//     return _cards[0];
//   }
//
//   Card getNextCard() {
//     if (_cards.isEmpty || _currentIndex >= _cards.length - 1) {
//       throw RangeError('No more cards');
//     }
//     return _cards[++_currentIndex];
//   }
//
//   Key? getKey() {
//     if (_cards.isEmpty) {
//       throw RangeError('No cards available');
//     }
//     return _cards[_currentIndex].key;
//   }
//
//   void incrementCardIndex() {
//     if (_currentIndex < _cards.length - 1) {
//       _currentIndex++;
//     }
//   }
// }
// //
