import 'dart:async';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppinioSwiperDirection {
  left,
  right,
  top,
  bottom,
}

final swipeAsyncNotifierProvider =
AsyncNotifierProvider<SwipeAsyncNotifier, List<User>>(
    SwipeAsyncNotifier.new);

class SwipeAsyncNotifier extends AsyncNotifier<List<User>> {
  @override
  // 初期値にUserデータを生成
  FutureOr<List<User>> build() {
    return List<User>.generate(5, (index) {
      return User(
        profileImageURL: ["assets/images/flutter.png"],
        name: "ジョン${index + 1}",
      );
    });
  }

  // スワイプ時の処理
  Future<void> swipeOnCard(
      AppinioSwiperDirection direction, // スワイプ方向を受け取る
      ) async {
    switch (direction) {
      case AppinioSwiperDirection.left: // 左方向
        _handleLeftSwipe();
        break;
      case AppinioSwiperDirection.right: // 右方向
        _handleRightSwipe();
        break;
      case AppinioSwiperDirection.top: // 上方向
        _handleTopSwipe();
        break;
      case AppinioSwiperDirection.bottom: // 下方向
        _handleBottomSwipe();
        break;
      default:
        print("未知のスワイプ方向です");
    }
  }

  // 左スワイプの処理
  void _handleLeftSwipe() {
    if (state is AsyncData<List<User>>) {
      state = AsyncValue.data([
        for (var i = 1; i < state.value!.length; i++) state.value![i],
      ]);
      print("左にスワイプされ、最初のユーザーが削除されました");
    } else {
      print("データがロードされていません");
    }
  }

  // 右スワイプの処理
  void _handleRightSwipe() {
    if (state is AsyncData<List<User>>) {
      state = AsyncValue.data([
        for (var i = 1; i < state.value!.length; i++) state.value![i],
      ]);
      print("右にスワイプされ、最初のユーザーが削除されました");
    } else {
      print("データがロードされていません");
    }
  }

  // 上スワイプの処理
  void _handleTopSwipe() {
    if (state is AsyncData<List<User>>) {
      print("上にスワイプされました");
    } else {
      print("データがロードされていません");
    }
  }

  // 下スワイプの処理
  void _handleBottomSwipe() {
    if (state is AsyncData<List<User>>) {
      print("下にスワイプされました");
    } else {
      print("データがロードされていません");
    }
  }
}


// import 'dart:async';
//
// import 'package:appinio_swiper/appinio_swiper.dart';
// import 'user.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final swipeAsyncNotifierProvider =
// AsyncNotifierProvider<SwipeAsyncNotifier, List<User>>(
//     SwipeAsyncNotifier.new);
//
// class SwipeAsyncNotifier extends AsyncNotifier<List<User>> {
//   @override
//   // 初期値にUserデータを生成
//   FutureOr<List<User>> build() {
//     return List<User>.generate(5, (index) {
//       return User(
//         profileImageURL: ["assets/images/flutter.png"],
//         name: "ジョン${index + 1}",
//       );
//     });
//   }
//
//   // スワイプ時の処理
//   Future<void> swipeOnCard(
//       AppinioSwiperDirection direction,
//       ) async {
//     switch (direction) {
//       case AppinioSwiperDirection.left: // 左方向
//       // 左方向にスワイプした時の処理
//         _handleLeftSwipe();
//         break;
//       case AppinioSwiperDirection.right: // 右方向
//       // 右方向にスワイプした時の処理
//         _handleRightSwipe();
//         break;
//     // case AppinioSwiperDirection.top: // 上方向
//     // // 上方向にスワイプした時の処理
//     //   break;
//     // case AppinioSwiperDirection.bottom: // 下方向
//     // // 下方向にスワイプした時の処理
//     //   break;
//     //   default:
//     }
//   }
//
//   // 左スワイプのとき
//   void _handleLeftSwipe() {
//     // 現在のリストを取得して、最初の要素を削除
//     if (state is AsyncData<List<User>>) {
//       // データが存在する場合のみ処理
//       state = AsyncValue.data([
//         for (var i = 1; i < state.value!.length; i++) state.value![i],
//       ]);
//       print("左にスワイプされ、最初のユーザーが削除されました");
//     } else {
//       print("データがロードされていません");
//     }
//   }
//
//   //右スワイプのとき
//   void _handleRightSwipe() {
//     // 現在のリストを取得して、最初の要素を削除
//     if (state is AsyncData<List<User>>) {
//       // データが存在する場合のみ処理
//       state = AsyncValue.data([
//         for (var i = 1; i < state.value!.length; i++) state.value![i],
//       ]);
//       print("左にスワイプされ、最初のユーザーが削除されました");
//     } else {
//       print("データがロードされていません");
//     }
//   }
// }