import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikeToList extends StatefulWidget {
  final int currentUserId;

  const LikeToList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _LikeToListState createState() => _LikeToListState();
}

class _LikeToListState extends State<LikeToList> {
  late Future<List<LikeToUser>> _likeToUsersFuture;

  @override
  void initState() {
    super.initState();
    _likeToUsersFuture = _fetchLikeToUsers();
  }

  Future<List<LikeToUser>> _fetchLikeToUsers() async {
    final List<LikeToUser> likeToUsers = [];

    try {
      final likes = await FirebaseFirestore.instance
          .collection('likes')
          .where('likeTo', isEqualTo: widget.currentUserId)
          .get();

      for (var doc in likes.docs) {
        int likeFromUserId = doc['likeFrom'];

        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: likeFromUserId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          likeToUsers.add(LikeToUser(
            name: userData['email'] ?? '名前なし',
            userId: likeFromUserId,
            likeDocId: doc.id,
          ));
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
    return likeToUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたをLIKEしたユーザー'),
      ),
      body: FutureBuilder<List<LikeToUser>>(
        future: _likeToUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("エラーが発生しました"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("あなたをLIKEしたユーザーがいません"));
          } else {
            final likeToUsers = snapshot.data!;
            return ListView.builder(
              itemCount: likeToUsers.length,
              itemBuilder: (context, index) {
                final likeToUser = likeToUsers[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(likeToUser.name),
                      subtitle: Text('ユーザーID: ${likeToUser.userId}'),
                    ),
                    const Divider(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class LikeToUser {
  final String name;
  final int userId;
  final String likeDocId;

  LikeToUser({
    required this.name,
    required this.userId,
    required this.likeDocId,
  });
}
