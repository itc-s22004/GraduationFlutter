import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat一覧'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Firestoreから取得したドキュメントをリストに変換
          final users = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return User(
              email: data['email'] ?? 'No Email',
              userId: data['id'] ?? 0,
            );
          }).toList();

          // ListViewでデータを表示
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.email),
                subtitle: Text('User ID: ${user.userId}'),
              );
            },
          );
        },
      ),
    );
  }
}

class User {
  final String email;
  final int userId;

  User({required this.email, required this.userId});
}


// import 'package:flutter/material.dart';
//
// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('Chat一覧'),
//       ),
//       body: const Center(
//         child: Text('ChatList画面', style: TextStyle(fontSize: 32.0)),
//       ),
//     );
//   }
// }
