import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omg/with/swipeAsyncNotifier.dart';
import 'package:omg/with/user_details.dart';
import 'user.dart';
import 'package:flutter/material.dart';
import 'package:omg/with/swipeAsyncNotifier.dart' as asyncNotifier;

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
          border: Border.all(color: Colors.black, width: 1),
          image: DecorationImage(
              image: AssetImage(user.profileImageURL.isNotEmpty ? user.profileImageURL[0] : 'default_image.png'),
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
              _buildText(user.mbti),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: user.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ),
        ),
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
          widthFactor: 0.9,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: UserDetailsPanel(user: user),
          ),
        );
      },
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

  Widget _buildText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}