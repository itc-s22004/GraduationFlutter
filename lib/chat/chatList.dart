import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth_controller.dart';
import 'chatRoom.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat一覧'),
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
            return ListView.builder(
              itemCount: matchedUsers.length,
              itemBuilder: (context, index) {
                final user = matchedUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('ユーザーID: ${user.userId}'),
                  onTap: () {
                    Get.to(() => ChatRoom(
                      userId: user.userId,
                      userName: user.name,
                    ));
                  },
                );

              },
            );
          }
        },
      ),
    );
  }

  Future<List<ChatUser>> _fetchMatchedUsers(int currentUserId) async {
    final List<ChatUser> matchedUsers = [];

    try {
      // `matches` コレクションから currentUserId が `user1` または `user2` のものを取得
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
  final int userId;

  ChatUser({
    required this.name,
    required this.userId,
  });
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../auth_controller.dart';
//
// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get
//         .find();
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme
//             .of(context)
//             .colorScheme
//             .inversePrimary,
//         title: const Text('Chat一覧'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'メールアドレス: ${authController.email}',
//               style: const TextStyle(fontSize: 24.0),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'ユーザーID: ${authController.userId}',
//               style: const TextStyle(fontSize: 24.0),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }