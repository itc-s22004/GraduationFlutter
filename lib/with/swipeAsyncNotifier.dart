import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_controller.dart';
import 'user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'dart:math';

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
      String currentUserMBTI = authController.diagnosis.value;
      List<String> currentUserTags = authController.tags.value;

      // matchesコレクションからすでにマッチングしているユーザーを取得
      final matchesSnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('user1', isEqualTo: loggedInUserId)
          .get();
      final reverseMatchesSnapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('user2', isEqualTo: loggedInUserId)
          .get();

      // マッチング済みのユーザーIDをリストに追加
      Set<int> matchedUserIds = {};
      matchesSnapshot.docs.forEach((doc) {
        matchedUserIds.add(doc.data()['user2']);
      });
      reverseMatchesSnapshot.docs.forEach((doc) {
        matchedUserIds.add(doc.data()['user1']);
      });

      // usersコレクションから全ユーザーを取得
      final snapshot = await FirebaseFirestore.instance.collection('users').get();

      List<User> highScoreUsers = [];
      List<User> lowScoreUsers = [];

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        int userId = data['id'] ?? 0;

        // 自分自身とマッチング済みのユーザーを除外
        if (userId == loggedInUserId || matchedUserIds.contains(userId)) return;

        final String dataMBTI = data['diagnosis'] ?? '不明';
        User user = User(
            name: data['email'] ?? 'No Email',
            mbti: dataMBTI,
            profileImageURL: ["assets/images/${dataMBTI}.png"],
            userId: userId,
            tags: List<String>.from(data['tag'] ?? []),
            school: data['school'] ?? 'No School',
            introduction: data['introduction'] ?? 'No introduction',
            gender: data['gender']
        );

        // スコア計算
        int mbtiScore = _getMBTIScore(currentUserMBTI, user.mbti);
        int tagScore = _getTagScore(currentUserTags, user.tags);
        int totalScore = mbtiScore + tagScore;

        print("ユーザー ${user.name} (ID: ${user.userId}): MBTIスコア = $mbtiScore, タグスコア = $tagScore, 合計スコア = $totalScore");

        if (totalScore >= 3) {
          highScoreUsers.add(user);
        } else {
          lowScoreUsers.add(user);
        }
      });

      // ユーザーリストをランダム化
      highScoreUsers.shuffle(Random());
      lowScoreUsers.shuffle(Random());

      List<User> sortedUsers = [...highScoreUsers, ...lowScoreUsers];
      return sortedUsers;
    } catch (e) {
      print("Error fetching users from Firestore: $e");
      return [];
    }
  }

  int _getMBTIScore(String currentUserMBTI, String userMBTI) {
    final Map<String, List<String>> mbtiCompatibility = {
      'はむさん': ['いぬさん', 'ひつじさん', 'とりさん', ],
      'ねこさん': ['さるさん', 'へびさん', 'うしさん', ],
      'へびさん': ['とりさん', 'はむさん', 'さるさん', ],
      'ひつじさん': ['とりさん', 'はむさん', 'いぬさん', ],


      'さるさん': ['ねこさん', 'うしさん', 'へびさん', ],
      'いぬさん': ['はむさん', 'とりさん', 'ひつじさん', ],
      'とりさん': ['ひつじさん', 'いぬさん', 'はむさん', ],
      'うしさん': ['へびさん', 'さるさん', 'ねこさん', ],
      // 'INT': ['ESF', 'ISF', 'ENT', ],
      // 'INF': ['EST', 'IST', 'ENF', ],
      // 'IST': ['ENF', 'INF', 'EST', ],
      // 'ISF': ['ENT', 'INT', 'ESF', ],
      //
      //
      // 'EST': ['INF', 'ENF', 'IST', ],
      // 'ESF': ['INT', 'ENT', 'ISF', ],
      // 'ENT': ['ISF', 'ESF', 'INT', ],
      // 'ENF': ['IST', 'EST', 'INF', ],
    };

    List<String> compatibleTypes = mbtiCompatibility[currentUserMBTI] ?? [];
    int score = 0;

    for (int i = 0; i < compatibleTypes.length; i++) {
      if (userMBTI == compatibleTypes[i]) {
        score = 3 - i;
        break;
      }
    }
    return score;
  }

  int _getTagScore(List<String> currentUserTags, List<String> userTags) {
    int score = 0;
    for (var tag in currentUserTags) {
      if (userTags.contains(tag)) {
        score += 1;
      }
    }
    return score;
  }

  @override
  FutureOr<List<User>> build() async {
    authController.diagnosis.listen((_) => _refreshUserData()); // AuthControllerの変更の監視
    authController.tags.listen((_) => _refreshUserData());
    return await fetchUsersFromFirestore();
  }

  Future<void> _refreshUserData() async {
    final updatedUsers = await fetchUsersFromFirestore();
    state = AsyncValue.data(updatedUsers);
  }

  Future<void> swipeOnCard(AppinioSwiperDirection direction) async {
    print("スワイプされた方向: $direction");
    switch (direction) {
      case AppinioSwiperDirection.left:
        await _handleLeftSwipe();
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

  void _showNextUser() {
    if (currentIndex < state.value!.length - 1) {
      currentIndex++;
      print("次のユーザーを表示: ${state.value![currentIndex].name}");
      state = AsyncValue.data(state.value!);
    } else {
      print("全ユーザーを表示しました");
    }
  }

  Future<void> _handleLeftSwipe() async {
    try {
      int currentUserId = authController.userId.value ?? 0;
      int swipedUserId = state.value![currentIndex].userId;

      await FirebaseFirestore.instance.collection('nope').add({
        'nopeFrom': currentUserId,
        'nopeTo': swipedUserId,
        'timestamp': FieldValue.serverTimestamp()
      });

      print("NOT: X $currentUserId -> $swipedUserId");
      _showNextUser();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _handleRightSwipe() async {
    try {
      final likeCollection = FirebaseFirestore.instance.collection('likes');

      int currentUserId = authController.userId.value ?? 0;
      int swipedUserId = state.value![currentIndex].userId;

      authController.swipedUserId.value = swipedUserId; // スワイプされたユーザーIDを保存

      await FirebaseFirestore.instance.collection('likes').add({
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
}