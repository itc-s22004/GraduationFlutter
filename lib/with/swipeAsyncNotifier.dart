import 'dart:async';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<User>> fetchUsersFromFirestore() async {
    try {
      // 'users' コレクションから全ユーザーを取得
      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      // Userデータを作成
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          profileImageURL: ["assets/images/flutter.png"],  // 固定値の画像
          name: data['email'] ?? 'No Email',  // 'email'フィールドを使用
        );
      }).toList();

      return users;
    } catch (e) {
      print("Error fetching users from Firestore: $e");
      return [];
    }
  }

  @override
  FutureOr<List<User>> build() async {
    // Firestoreからユーザーを取得して返す
    return await fetchUsersFromFirestore();
  }

  Future<void> swipeOnCard(   // スワイプ時の処理
      AppinioSwiperDirection direction, // スワイプ方向を受け取る
      ) async {
    switch (direction) {
      case AppinioSwiperDirection.left: // 左方向
        _handleLeftSwipe();  // NOT 削除
        break;
      case AppinioSwiperDirection.right: // 右方向
        _handleRightSwipe();  // LIKE リストに登録？　　右スワイプも今は削除だから変更する
        break;
      // case AppinioSwiperDirection.top: // 上方向
      //   _handleTopSwipe();
      //   break;
      // case AppinioSwiperDirection.bottom: // 下方向
      //   _handleBottomSwipe();
      //   break;
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
}