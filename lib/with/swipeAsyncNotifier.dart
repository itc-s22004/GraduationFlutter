import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'dart:math'; // ランダム化のために追加

enum AppinioSwiperDirection {
  left,
  right,
  top,
  bottom,
}

final swipeAsyncNotifierProvider =
AsyncNotifierProvider<SwipeAsyncNotifier, List<User>>(
  SwipeAsyncNotifier.new,
);

class SwipeAsyncNotifier extends AsyncNotifier<List<User>> {
  late final int currentUserId; // 現在のユーザーIDを保持するフィールド
  final AuthController authController = Get.find<AuthController>(); // AuthControllerのインスタンスを取得
  int currentIndex = 0; // 現在表示しているユーザーのインデックス

  Future<List<User>> fetchUsersFromFirestore() async {
    try {
      // 'users' コレクションから全ユーザーを取得
      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      // Userデータを作成
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        print("Fetched user data: $data"); // 追加: 取得したデータを表示
        return User(
          profileImageURL: ["assets/images/flutter.png"], // 固定値の画像
          name: data['email'] ?? 'No Email', // 'email'フィールドを使用
          userId: data['id'] ?? 0, // FirestoreからuserIdを取得
        );
      }).toList();

      // ユーザーリストをランダムにシャッフル
      users.shuffle(Random());

      print("Fetched users: $users"); // 追加: 取得したユーザーリストを表示
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

  Future<void> swipeOnCard(AppinioSwiperDirection direction) async {
    print("スワイプされた方向: $direction"); // 追加
    switch (direction) {
      case AppinioSwiperDirection.left:
        _handleLeftSwipe();
        print("左スライド");
        break;
      case AppinioSwiperDirection.right:
        _handleRightSwipe();
        print("右スライド");
        break;
      default:
        print("未知のスワイプ方向です");
    }
  }

  void _handleLeftSwipe() {
    _showNextUser();
  }

  void _handleRightSwipe() async {
    try {
      // 現在ログインしているユーザーIDとスワイプされたユーザーIDを取得
      int currentUserId = authController.userId.value ?? 0;
      int swipedUserId = state.value![currentIndex].userId;

      // Firestoreに「いいね」を追加
      await FirebaseFirestore.instance.collection('likes').add({
        'likeFrom': currentUserId,
        'likeTo': swipedUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("いいねを追加しました: $currentUserId -> $swipedUserId");
      _showNextUser();
    } catch (e) {
      print("Firebaseへの保存中にエラーが発生しました: $e");
    }
  }

  void _showNextUser() {
    // インデックスを進めて次のユーザーを表示
    if (currentIndex < state.value!.length - 1) {
      currentIndex++;
      print("次のユーザーを表示: ${state.value![currentIndex].name}");
      state = AsyncValue.data(state.value!); // インデックスが進むだけでユーザーリストはそのまま
    } else {
      print("全ユーザーを表示しました");
    }
  }
}