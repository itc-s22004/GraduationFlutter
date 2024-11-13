import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_controller.dart';
import 'chatRoom.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Chat一覧 - ${authController.email.value}'),
      ),
      body: FutureBuilder<List<ChatUser>>(
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
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/${user.mbti}.jpg'),
                    backgroundColor: Colors.grey[200],
                    radius: 24,
                  ),
                  title: Text(user.name),
                  subtitle: Text('ユーザーID: ${user.userId}\nMBTI: ${user.mbti}'),
                  onTap: () {
                    Get.to(() => ChatRoom(
                      userId: user.userId,
                      userName: user.name,
                    ));
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider()
            );
          }
        },
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