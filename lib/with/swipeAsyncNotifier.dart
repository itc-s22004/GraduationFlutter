import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';


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
  late final int currentUserId; // 現在のユーザーIDを保持するフィールド
  final AuthController authController = Get.find<AuthController>(); // AuthControllerのインスタンスを取得

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
          userId: data['userId'] ?? 0, // FirestoreからuserIdを取得
        );
      }).toList();

      print("Fetched users: $users"); // 追加: 取得したユーザーリストを表示
      print("aldsfja;lsdfj;lasjd;lfajs;ldfja;lsdjf;lkasjdlkfajsldkfjas------------------------------");
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
    if (state is AsyncData<List<User>>) {
      state = AsyncValue.data([
        for (var i = 1; i < state.value!.length; i++) state.value![i],
      ]);
      print("左にスワイプされ、最初のユーザーが削除されました");
    } else {
      print("データがロードされていません");
    }
  }

  void _handleRightSwipe() async {
    if (state is AsyncData<List<User>>) {
      try {
        await FirebaseFirestore.instance.collection('likes').add({
          'likeFrom': 7,
          'likeTo': 5, // 最初のユーザーのID
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("ユーザーにいいねが追加されました");

        // 最初のユーザーをリストから削除
        state = AsyncValue.data([
          for (var i = 1; i < state.value!.length; i++) state.value![i],
        ]);
      } catch (e) {
        print("Firebaseへの保存中にエラーが発生しました: $e");
      }
    } else {
      print("データがロードされていません");
    }
  }
}