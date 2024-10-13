import 'package:appinio_swiper/appinio_swiper.dart';
import 'user.dart';
import 'package:flutter/material.dart';


enum AppinioSwiperDirection {
  left,
  right,
  top,
  bottom,
}

class SwipeCard extends StatelessWidget {
  const SwipeCard({
    super.key,
    required this.list,
    required this.onSwiping,
    required this.controller,
  });

  final List<User> list;
  final AppinioSwiperController controller;
  // final void Function(AppinioSwiperDirection direction) onSwiping;
  final void Function(int index, AppinioSwiperDirection direction) onSwiping; // 修正


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AppinioSwiper(
            controller: controller, // スワイプを制御するコントローラー
            cardCount: list.length, // カードの数
            onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
              // スワイプが進行中かどうかを確認
              if (activity is Swipe) {
                print("スワイプが進行中です。");
                return;
              }

              // スワイプが終了した場合の処理
              if (activity is DrivenActivity) {
                // スワイプの方向を適切に処理する
                onSwiping(targetIndex, activity.direction as AppinioSwiperDirection); // directionを取得

              }
            },
            // onSwipeEnd: (int index, AppinioSwiperDirection? direction) {
            //   if (direction != null) {
            //     onSwiping(index, direction);
            //   }
            // },
            // onSwipeEnd: onSwiping,
            cardBuilder: (BuildContext context, int index) {
              final user = list[index];
              return list.isNotEmpty
                  ? _buildCard(user: user) // カード型ウィジェット
                  : Center(child: _buildText("No Data"));
            },
          ),
        ),
        _buildActionButton(controller), // アクションボタン
        const SizedBox(height: 10),
      ],
    );
  }

  // カード型コンポーネント
  Widget _buildCard({required User user}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1),
        image: DecorationImage(
            image: AssetImage(user.profileImageURL[0]),
            fit: BoxFit.cover,
            alignment: Alignment.center),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildText(user.name),
          ],
        ),
      ),
    );
  }

  // アクションボタンコンポーネント
  Widget _buildActionButton(AppinioSwiperController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCustomBtn(
          onPressed: () {
            controller.swipeLeft(); // 左方向にスワイプ
          },
          iconData: Icons.cancel,
          color: Colors.red,
        ),
        _buildCustomBtn(
          onPressed: () {
            controller.swipeUp(); // 上方向にスワイプ
          },
          iconData: Icons.star,
          color: Colors.blue,
        ),
        _buildCustomBtn(
          onPressed: () {
            controller.swipeRight(); // 右方向にスワイプ
          },
          iconData: Icons.favorite,
          color: Colors.teal,
        ),
      ],
    );
  }

  // ボタンコンポーネント
  Widget _buildCustomBtn({
    required void Function()? onPressed,
    required IconData iconData,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 8,
        shape: const CircleBorder(),
        minimumSize: const Size.square(50),
      ),
      child: Icon(
        iconData,
        color: color,
      ),
    );
  }

  // テキストコンポーネント
  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}