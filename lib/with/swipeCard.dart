import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:omg/with/swipeAsyncNotifier.dart' as asyncNotifier;
import 'package:omg/with/swipeAsyncNotifier.dart';
import 'user.dart';
import 'package:omg/with/user_details.dart';

class SwipeCard extends ConsumerWidget {
  const SwipeCard({
    super.key,
    required this.list,
    required this.onSwiping,
    required this.controller,
  });

  final List<User> list;
  final AppinioSwiperController controller;
  final void Function(AppinioSwiperDirection direction) onSwiping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swipeNotifier = ref.read(asyncNotifier.swipeAsyncNotifierProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: AppinioSwiper(
            controller: controller,
            cardCount: list.length,
            onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
              if (activity is Swipe) {
                AppinioSwiperDirection direction;
                switch (activity.direction) {
                  case AxisDirection.left:
                    direction = AppinioSwiperDirection.left;
                    break;
                  case AxisDirection.right:
                    direction = AppinioSwiperDirection.right;
                    break;
                  default:
                    return;
                }
                swipeNotifier.swipeOnCard(direction);
              }
            },
            cardBuilder: (BuildContext context, int index) {
              final user = list[index];
              return _buildCard(context, user);
            },
          ),
        ),
        _buildActionButton(controller),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCard(BuildContext context, User user) {
    return GestureDetector(
      onTap: () {
        _showUserDetails(context, user);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400, width: 2),
          image: DecorationImage(
              image: AssetImage(user.profileImageURL.isNotEmpty ? user.profileImageURL[0] : 'assets/default_image.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText(user.name, 22, Colors.black),
                  _buildText(user.mbti, 18, Colors.black),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: user.tags.map((tag) => _buildTag(tag)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text, double fontSize, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [Shadow(color: Colors.black.withOpacity(0.5), offset: const Offset(2, 2), blurRadius: 4)],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Chip(
      label: Text(
        tag,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      backgroundColor: Colors.teal.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8, // パネルの高さを調整
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(user.profileImageURL.isNotEmpty ? user.profileImageURL[0] : 'assets/default_image.png'),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.mbti,
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: user.tags.map((tag) => _buildTag(tag)).toList(),
                ),
                const SizedBox(height: 20),

                // その他の詳細
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.school, "学校", user.school),
                        _buildDetailRow(Icons.abc, "自己紹介", user.introduction),
                      ],
                    ),
                  ),
                ),

                // アクションボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionBtn(Icons.chat, "削除", Colors.blue),
                    _buildActionBtn(Icons.favorite, "いいね", Colors.red),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildDetailRow(IconData icon, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // アイコンとテキストを上揃え
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 8),
          Flexible( // 改行対応
            child: Text(
              "$title: $detail",
              style: const TextStyle(fontSize: 16),
              softWrap: true, // 改行を許可
            ),
          ),
        ],
      ),
    );
  }


  // Widget _buildDetailRow(IconData icon, String title, String detail) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: [
  //         Icon(icon, color: Colors.teal),
  //         const SizedBox(width: 8),
  //         Text(
  //           "$title: $detail",
  //           style: const TextStyle(fontSize: 16),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActionBtn(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }


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
}