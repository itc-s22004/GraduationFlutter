import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../auth_controller.dart';
import 'user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'dart:math'; // ランダム化のために追加

enum AppinioSwiperDirection {
  left,
  right,
  top,
  bottom,
}

final swipeAsyncNotifierProvider = AsyncNotifierProvider<SwipeAsyncNotifier, List<User>>(
  SwipeAsyncNotifier.new,
);

class SwipeAsyncNotifier extends AsyncNotifier<List<User>> {
  late final int currentUserId; // 現在のユーザーIDを保持するフィールド
  final AuthController authController = Get.find<AuthController>(); // AuthControllerのインスタンスを取得
  int currentIndex = 0; // 現在表示しているユーザーのインデックス

  Future<List<User>> fetchUsersFromFirestore() async {
    try {
      int loggedInUserId = authController.userId.value ?? 0;

      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      final users = snapshot.docs.where((doc) {
        final data = doc.data();
        int userId = data['id'] ?? 0;
        return userId != loggedInUserId;
      }).map((doc) {
        final data = doc.data();
        print("Fetched user data: $data");
        return User(
          profileImageURL: ["assets/images/flutter.png"],
          name: data['email'] ?? 'No Email',
          userId: data['id'] ?? 0,
        );
      }).toList();

      users.shuffle(Random());

      print("Filtered users (excluding logged in user): $users");
      return users;
    } catch (e) {
      print("Error fetching users from Firestore: $e");
      return [];
    }
  }


  @override
  FutureOr<List<User>> build() async {
    return await fetchUsersFromFirestore();
  }

  Future<void> swipeOnCard(AppinioSwiperDirection direction) async {
    print("スワイプされた方向: $direction");
    switch (direction) {
      case AppinioSwiperDirection.left:
        _handleLeftSwipe();
        print("左スライド");
        break;
      case AppinioSwiperDirection.right:
        await _handleRightSwipe();
        print("右スライド");
        break;
      default:
        print("未知のスワイプ方向です");
    }
  }

  Future<void> _handle() async {
    try {
      int currentUserId = authController.userId.value ?? 0;
      int swipedUserId = state.value![currentIndex].userId;

      print("NOT: X $currentUserId -> $swipedUserId");

    } catch (e) {
      print(e);
    }
  }

  void _handleLeftSwipe() {
    _handle();
    _showNextUser();
  }

  Future<void> _handleRightSwipe() async {
    try {
      final likeCollection = FirebaseFirestore.instance.collection('likes');
      final snapshot = await likeCollection.get();
      final likeCount = snapshot.size + 1;

      String likeId = 'like$likeCount';

      int currentUserId = authController.userId.value ?? 0;
      int swipedUserId = state.value![currentIndex].userId;

      await FirebaseFirestore.instance.collection('likes').doc(likeId).set({
        'likeFrom': currentUserId,
        'likeTo': swipedUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      final reverseLikeSnapshot = await likeCollection
          .where('likeFrom', isEqualTo: swipedUserId)
          .where('likeTo', isEqualTo: currentUserId)
          .get();

      if (reverseLikeSnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance.collection('matches').add({
          'user1': currentUserId,
          'user2': swipedUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("マッチングしました: $currentUserId と $swipedUserId");
      }

      print("いいねを追加しました: $currentUserId -> $swipedUserId");
      _showNextUser();
    } catch (e) {
      print("Firebaseへの保存中にエラーが発生しました: $e");
    }
  }

  void _showNextUser() {
    if (currentIndex < state.value!.length - 1) {
      currentIndex++;
      print("次のユーザーを表示: ${state.value![currentIndex].name}");
      state = AsyncValue.data(state.value!);
    } else {
      print("全ユーザーを表示しました");
    }
  }
}