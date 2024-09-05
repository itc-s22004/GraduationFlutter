import 'package:flutter/material.dart';
import 'package:omg/swipe/stacked_card.dart';
import 'package:omg/swipe/stacked_card_set.dart';
import 'package:omg/swipe/stacked_card_view.dart';

class Next extends StatelessWidget {
  const Next({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text('result2'),
  //           ],
  //         )
  //     ),
  //   );
  // }
  //
  @override
  Widget build(BuildContext context)
  {
    final cardSet = StackedCardSet(
      cards: [
        StackedCard(
          photos: [
            'images/profile1.jpg',
            'images/profile2.jpg',
            'images/profile3.jpg',
          ],
          title: 'Your Name',
          subTitle: 'And Biography', key: '',
        ),
        StackedCard(
          photos: [
            'images/profile4.jpg',
            'images/profile5.jpg',
            'images/profile6.jpg',
          ],
          title: '名前',
          subTitle: '自己紹介', key: '',
        ),
        StackedCard(
          photos: [
            'images/profile7.jpg',
            'images/profile8.jpg',
            'images/profile9.jpg',
          ],
          title: 'Text here',
          subTitle: 'Text here', key: '',
        ),
      ],
    );

    return StackedCardView(
      cardSet: cardSet,
    );
  }
}

