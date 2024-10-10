import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class MySwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppinioSwiper(
        cardBuilder: (context, index) {   //仕様が変わったようでcardBuilderを使うみたい
          return Card(
            child: Center(
              child: Text('Item $index'),
            ),
          );
        },
        cardCount: 10,
        // direction: AppinioSwiperDirection.left, // この行が必要な場合
      ),
    );
  }
}

//なくてもいいかな
