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
        _showUserDetails(context, user); // スライドパネル
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
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: user.tags.map((tag) => Chip(label: Text(tag))).toList(), // タグ
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
      builder: (context) {
        return UserDetailsPanel(user: user); // UserDetailsPanel
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




// import 'package:appinio_swiper/appinio_swiper.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:omg/with/swipeAsyncNotifier.dart';
// import 'user.dart';
// import 'package:flutter/material.dart';
// import 'package:omg/with/swipeAsyncNotifier.dart' as asyncNotifier;
//
// class SwipeCard extends ConsumerWidget {
//   const SwipeCard({
//     super.key,
//     required this.list,
//     required this.onSwiping,
//     required this.controller,
//   });
//
//   final List<User> list;
//   final AppinioSwiperController controller;
//   final void Function(AppinioSwiperDirection direction) onSwiping;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final swipeNotifier = ref.read(asyncNotifier.swipeAsyncNotifierProvider.notifier);
//
//     return Column(
//       children: [
//         Expanded(
//           child: AppinioSwiper(
//             controller: controller,
//             cardCount: list.length,
//             onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
//               if (activity is Swipe) {
//                 print("スワイプが終了しました（Swipe）");
//
//                 AppinioSwiperDirection direction;
//                 switch (activity.direction) {
//                   case AxisDirection.left:
//                     direction = AppinioSwiperDirection.left;
//                     break;
//                   case AxisDirection.right:
//                     direction = AppinioSwiperDirection.right;
//                     break;
//                   default:
//                     print("未知の方向です");
//                     return;
//                 }
//                 swipeNotifier.swipeOnCard(direction);
//               }
//             },
//             cardBuilder: (BuildContext context, int index) {
//               final user = list[index];
//               return list.isNotEmpty
//                   ? _buildCard(user: user)
//                   : Center(child: _buildText("No Data"));
//             },
//           ),
//         ),
//         _buildActionButton(controller),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
//
//   Widget _buildCard({required User user}) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.black, width: 1),
//         image: DecorationImage(
//             image: AssetImage(user.profileImageURL.isNotEmpty ? user.profileImageURL[0] : 'default_image.png'), // デフォルト画像を設定
//             fit: BoxFit.cover,
//             alignment: Alignment.center),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ユーザーの名前を表示しない場合はコメントアウト
//             _buildText(user.name),
//             const SizedBox(height: 8), // 余白
//             Wrap(
//               spacing: 8.0,
//               children: user.tags.map((tag) => Chip(label: Text(tag))).toList(), // タグの表示
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton(AppinioSwiperController controller) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildCustomBtn(
//           onPressed: () {
//             controller.swipeLeft(); // 左方向にスワイプ
//           },
//           iconData: Icons.cancel,
//           color: Colors.red,
//         ),
//         _buildCustomBtn(
//           onPressed: () {
//             controller.swipeUp(); // 上方向にスワイプ
//           },
//           iconData: Icons.star,
//           color: Colors.blue,
//         ),
//         _buildCustomBtn(
//           onPressed: () {
//             controller.swipeRight(); // 右方向にスワイプ
//           },
//           iconData: Icons.favorite,
//           color: Colors.teal,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCustomBtn({
//     required void Function()? onPressed,
//     required IconData iconData,
//     required Color color,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         elevation: 8,
//         shape: const CircleBorder(),
//         minimumSize: const Size.square(50),
//       ),
//       child: Icon(
//         iconData,
//         color: color,
//       ),
//     );
//   }
//
//   Widget _buildText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }
// }

// -----------------------------------------------------------

// import 'package:appinio_swiper/appinio_swiper.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:omg/with/swipeAsyncNotifier.dart';
// import 'user.dart';
// import 'package:flutter/material.dart';
// import 'package:omg/with/swipeAsyncNotifier.dart' as asyncNotifier;
//
// class SwipeCard extends ConsumerWidget {
//   const SwipeCard({
//     super.key,
//     required this.list,
//     required this.onSwiping,
//     required this.controller,
//   });
//
//   final List<User> list;
//   final AppinioSwiperController controller;
//   final void Function(AppinioSwiperDirection direction) onSwiping;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final swipeNotifier = ref.read(asyncNotifier.swipeAsyncNotifierProvider.notifier);
//
//     return Column(
//       children: [
//         Expanded(
//           child: AppinioSwiper(
//             controller: controller,
//             cardCount: list.length,
//             onSwipeEnd: (int previousIndex, int targetIndex, SwiperActivity activity) {
//               if (activity is Swipe) {
//                 print("スワイプが終了しました（Swipe）");
//
//                 AppinioSwiperDirection direction;
//                 switch (activity.direction) {
//                   case AxisDirection.left:
//                     direction = AppinioSwiperDirection.left;
//                     break;
//                   case AxisDirection.right:
//                     direction = AppinioSwiperDirection.right;
//                     break;
//                   default:
//                     print("未知の方向です");
//                     return;
//                 }
//                 swipeNotifier.swipeOnCard(direction);
//               }
//             },
//             cardBuilder: (BuildContext context, int index) {
//               final user = list[index];
//               return list.isNotEmpty
//                   ? _buildCard(user: user)
//                   : Center(child: _buildText("No Data"));
//             },
//           ),
//         ),
//         _buildActionButton(controller),
//         const SizedBox(height: 10),
//       ],
//     );
//   }
//
//   Widget _buildCard({required User user}) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.black, width: 1),
//         image: DecorationImage(
//             image: AssetImage(user.profileImageURL[0]),
//             fit: BoxFit.cover,
//             alignment: Alignment.center),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildText(user.name),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton(AppinioSwiperController controller) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildCustomBtn(
//           onPressed: () {
//             controller.swipeLeft(); // 左方向にスワイプ
//           },
//           iconData: Icons.cancel,
//           color: Colors.red,
//         ),
//         _buildCustomBtn(
//           onPressed: () {
//             controller.swipeUp(); // 上方向にスワイプ
//           },
//           iconData: Icons.star,
//           color: Colors.blue,
//         ),
//         _buildCustomBtn(
//           onPressed: () {
//             controller.swipeRight(); // 右方向にスワイプ
//           },
//           iconData: Icons.favorite,
//           color: Colors.teal,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCustomBtn({
//     required void Function()? onPressed,
//     required IconData iconData,
//     required Color color,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.white,
//         elevation: 8,
//         shape: const CircleBorder(),
//         minimumSize: const Size.square(50),
//       ),
//       child: Icon(
//         iconData,
//         color: color,
//       ),
//     );
//   }
//
//   Widget _buildText(String text) {
//     return Text(
//       text,  // swipeCardの中のemailが入っている
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//     );
//   }
// }