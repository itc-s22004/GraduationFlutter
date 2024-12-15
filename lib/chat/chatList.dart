import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_controller.dart';
import '../utilities/constant.dart';
import 'chatRoom.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            // 背景色の部分
            Container(
              height: 500,
              color: kAppBtmBackground,
            ),
            // 背景が丸くなる部分（めり込むように位置を調整）
            Positioned(
              top: -50, // 上部に突き出す高さを調整
              left: 0,
              right: 0,
              child: Container(
                height: 1000,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200), // 丸みのデザインを維持
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            FutureBuilder<List<ChatUser>>(
              future: _fetchMatchedUsers(authController.userId.value),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('エラー: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('マッチングユーザーがいません'));
                } else {
                  final matchedUsers = snapshot.data!;
                  return ListView.separated(
                    itemCount: matchedUsers.length,
                    itemBuilder: (context, index) {
                      final user = matchedUsers[index];
                      return InkWell(
                        onTap: () {
                          Get.to(() => ChatRoom(
                            userId: user.userId,
                            userName: user.name,
                            mbti: user.mbti,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/${user.mbti}.png'),
                                backgroundColor: Colors.white,
                                radius: 35, // 写真のサイズ
                              ),
                              const SizedBox(width: 20.0), // 写真とテキストの間
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.name}\nユーザーID: ${user.userId}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4.0), // 上下のテキスト間の余白
                                    Text(
                                      'MBTI: ${user.mbti}',
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ChatUser>> _fetchMatchedUsers(int currentUserId) async {
    final List<ChatUser> matchedUsers = [];

    try {
      final user1Matches = await FirebaseFirestore.instance
          .collection('matches')
          .where('user1', isEqualTo: currentUserId)
          .get();

      final user2Matches = await FirebaseFirestore.instance
          .collection('matches')
          .where('user2', isEqualTo: currentUserId)
          .get();

      // `user1` に一致した `user2` の ID をリストに追加
      final otherUserIdsFromUser1 = user1Matches.docs.map((doc) => doc.data()['user2']).toList();
      // `user2` に一致した `user1` の ID をリストに追加
      final otherUserIdsFromUser2 = user2Matches.docs.map((doc) => doc.data()['user1']).toList();

      // 両方のユーザーIDをマージ
      final allOtherUserIds = [...otherUserIdsFromUser1, ...otherUserIdsFromUser2];

      if (allOtherUserIds.isNotEmpty) {
        // マッチしたユーザーのデータを取得
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', whereIn: allOtherUserIds)
            .get();

        // マッチしたユーザーをリストに追加
        for (var userDoc in userSnapshot.docs) {
          final userData = userDoc.data();
          matchedUsers.add(ChatUser(
            name: userData['email'] ?? '不明',
            mbti: userData['diagnosis'],
            userId: userData['id'],
          ));
        }
      }
    } catch (e) {
      print("Error fetching matched users: $e");
      throw e;
    }

    return matchedUsers;
  }
}

class ChatUser {
  final String name;
  final String mbti;
  final int userId;

  ChatUser({
    required this.name,
    required this.mbti,
    required this.userId,
  });
}