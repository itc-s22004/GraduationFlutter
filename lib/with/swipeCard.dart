import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:omg/with/swipeAsyncNotifier.dart' as asyncNotifier;
import 'package:omg/with/swipeAsyncNotifier.dart';
import '../utilities/constant.dart';
import 'user.dart';
import 'package:omg/comp/detailDesgin.dart';

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
  static const double cardSize = 210.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swipeNotifier = ref.read(
        asyncNotifier.swipeAsyncNotifierProvider.notifier);

    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: AppinioSwiper(
            controller: controller,
            cardCount: list.length,
            onSwipeEnd: (int previousIndex, int targetIndex,
                SwiperActivity activity) {
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
    final remainingCount = list.length - list.indexOf(user) - 1;

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _showUserDetails(context, user);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade400, width: 2),
              image: DecorationImage(
                image: AssetImage(
                    user.profileImageURL.isNotEmpty
                        ? user.profileImageURL[0]
                        : 'assets/default_image.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6), // 下から濃い黒
                          Colors.black.withOpacity(0.0), // 上は透明
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText(user.name, 22, Colors.white),
                        _buildText(user.mbti, 18, Colors.white),
                        const SizedBox(height: 8),
                        if (user.introduction != null &&
                            user.introduction.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              user.introduction,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Wrap(
                          spacing: 8.0,
                          children: user.tags.take(4).map((tag) =>
                              _buildTag(tag)).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 右上に残りの人数を表示
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '残り: $remainingCount 人',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText(String text, double fontSize, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: [
          Shadow(color: Colors.black.withOpacity(0.5),
              offset: const Offset(2, 2),
              blurRadius: 4)
        ],
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
          heightFactor: 0.8,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, left: 10.0),
                child: Column(
                  children: [  // -----------------------プロフィールのデザイン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildInfoCard(
                            context,
                            Icons.person,
                            '性別',
                            user.gender,
                            cardSize
                        ),
                        const SizedBox(width: 24),
                        buildInfoCard(
                            context,
                            Icons.school,
                            '学校',
                            user.school,
                            cardSize
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildInfoCard(
                          context,
                          Icons.person,
                          'MBTI',
                          user.mbti,
                          cardSize,
                        ),
                        const SizedBox(width: 24),
                        // 右側の写真カード
                        Builder(
                          builder: (context) {
                            double screenWidth = MediaQuery.of(context).size.width;
                            double photoCardSize = screenWidth * 0.42;
                            if (photoCardSize > 220.0) photoCardSize = 220.0;

                            return Container(
                              width: photoCardSize,
                              height: photoCardSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  "assets/images/${user.mbti}.jpg",
                                  width: photoCardSize,
                                  height: photoCardSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    buildIntroductionCard(
                      context,
                        user.introduction
                    ),
                    const SizedBox(height: 24),
                    buildTagsSection(context, user.tags)
                  ],
                ),
              ),
            ),
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
          iconSize: 30,
        ),
        _buildCustomBtn(
          onPressed: () {
            controller.swipeUp(); // 上方向にスワイプ
          },
          iconData: Icons.star,
          color: Colors.blue,
          iconSize: 30,
        ),
        _buildCustomBtn(
          onPressed: () {
            controller.swipeRight(); // 右方向にスワイプ
          },
          iconData: Icons.favorite,
          color: Colors.teal,
          iconSize: 30,
        ),
      ],
    );
  }


  Widget _buildCustomBtn({
    required void Function()? onPressed,
    required IconData iconData,
    required Color color,
    required double iconSize,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 8,
        shape: const CircleBorder(),
        minimumSize: const Size.square(70),
      ),
      child: Icon(
        iconData,
        color: color,
        size: iconSize,
      ),
    );
  }
}