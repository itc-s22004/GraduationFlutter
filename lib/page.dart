import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/swipe/stacked_card.dart';
import 'package:omg/swipe/stacked_card_set.dart';
import 'package:omg/swipe/stacked_card_view.dart';

import 'next.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('result1'),
            ElevatedButton(
              onPressed: _toNext,
              child: Text('Go to NextPage'),
            ),
          ],
        ),
      ),
    );
  }

  void _toNext() {
    Get.to(() => const Next());
  }

  // void _toStackedCardView() {
  //   final cardSet = StackedCardSet(
  //     cards: [
  //       StackedCard(
  //         photos: ['images/profile2.jpg'],
  //         title: 'Card 1',
  //         subTitle: 'Subtitle 1',
  //         key: 'card1',  // Key を指定
  //       ),
  //       StackedCard(
  //         photos: ['images/profile2.jpg'],
  //         title: 'Card 2',
  //         subTitle: 'Subtitle 2',
  //         key: 'card2',  // Key を指定
  //       ),
  //       StackedCard(
  //         photos: ['images/profile3.jpg'],
  //         title: 'Card 3',
  //         subTitle: 'Subtitle 3',
  //         key: 'card3',  // Key を指定
  //       ),
  //     ],
  //   );
  //
  //   // StackedCardSet を StackedCardView に渡す
  //   Get.to(() => StackedCardView(cardSet: cardSet));
  // }
}


//
// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('result1'),
//             ElevatedButton(
//               onPressed: _toStackedCardView,
//               child: Text('Go to Stacked Card View'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _toNext() {
//     Get.to(() => const Next());
//   }
//
//   // StackedCardSet に StackedCard を渡す
//   void _toStackedCardView() {
//     final cardSet = StackedCardSet(
//       cards: [
//         StackedCard(
//           photos: ['photo1.jpg', 'photo2.jpg'], // 必須引数として写真をリストで渡す
//           title: 'Card 1', // 必須引数としてタイトルを渡す
//           subTitle: 'Subtitle 1', content: '', // サブタイトル（オプション）
//         ),
//         StackedCard(
//           photos: ['photo3.jpg', 'photo4.jpg'],
//           title: 'Card 2',
//           subTitle: 'Subtitle 2', content: '',
//         ),
//         StackedCard(
//           photos: ['photo5.jpg', 'photo6.jpg'],
//           title: 'Card 3',
//           subTitle: 'Subtitle 3', content: '',
//         ),
//       ],
//     );
//
//     // StackedCardSet を StackedCardView に渡す
//     Get.to(() => StackedCardView(cardSet: cardSet));
//   }
// }
