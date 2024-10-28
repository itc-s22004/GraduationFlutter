// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../auth_controller.dart';
// import 'chat.dart';
// import 'chatRoom.dart'; // ChatRoom をインポート
//
// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.find();
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('Chat一覧'),
//       ),
//       body: FutureBuilder<List<ChatUser>>(
//         future: _fetchMatchedUsers(authController.userId.value),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('エラー: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('マッチングユーザーがいません'));
//           } else {
//             final matchedUsers = snapshot.data!;
//             return ListView.builder(
//               itemCount: matchedUsers.length,
//               itemBuilder: (context, index) {
//                 final user = matchedUsers[index];
//                 return ListTile(
//                   title: Text(user.name),
//                   subtitle: Text('ユーザーID: ${user.userId}'),
//                   onTap: () {
//                     // ユーザーIDと名前を渡してチャットルームに遷移
//                     Get.to(() => ChatRoom(userId: user.userId, userName: user.name));
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Future<List<ChatUser>> _fetchMatchedUsers(int currentUserId) async {
//     final List<ChatUser> matchedUsers = [];
//
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('matches')
//           .where('user1', isEqualTo: currentUserId)
//           .get();
//
//       final otherUserIds = snapshot.docs.map((doc) => doc.data()['user2']).toList();
//
//       if (otherUserIds.isNotEmpty) {
//         final userSnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('id', whereIn: otherUserIds)
//             .get();
//
//         for (var userDoc in userSnapshot.docs) {
//           final userData = userDoc.data();
//           matchedUsers.add(ChatUser(
//             name: userData['email'] ?? '不明',
//             userId: userData['id'],
//           ));
//         }
//       }
//     } catch (e) {
//       print("Error fetching matched users: $e");
//       throw e;
//     }
//
//     return matchedUsers;
//   }
// }
//
// class ChatUser {
//   final String name;
//   final int userId;
//
//   ChatUser({
//     required this.name,
//     required this.userId,
//   });
// }