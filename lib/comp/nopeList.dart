import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NopeList extends StatefulWidget {
  final int currentUserId;

  const NopeList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _NopeListState createState() => _NopeListState();
}

class _NopeListState extends State<NopeList> {
  late Future<List<NopeUser>> _nopeUsersFuture;

  @override
  void initState() {
    super.initState();
    _nopeUsersFuture = _fetchNopeUsers();
  }

  Future<List<NopeUser>> _fetchNopeUsers() async {
    final List<NopeUser> nopeUsers = [];

    try {
      final nopeMatches = await FirebaseFirestore.instance
          .collection('nope')
          .where('nopeFrom', isEqualTo: widget.currentUserId)
          .get();

      for (var doc in nopeMatches.docs) {
        int nopeToUserId = doc['nopeTo'];

        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: nopeToUserId)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          nopeUsers.add(NopeUser(
            name: userData['email'] ?? '名前なし',
            userId: nopeToUserId,
            nopeDocId: doc.id,
          ));
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
    return nopeUsers;
  }

  Future<void> _likeUser(int likeToUserId, NopeUser user) async {
    try {
      final likeCollection = FirebaseFirestore.instance.collection('nope');
      final snapshot = await likeCollection.get();
      final likeCount = snapshot.size + 1;

      String likeId = 'like$likeCount';

      await FirebaseFirestore.instance.collection('likes').doc(likeId).set({
        'likeFrom': widget.currentUserId,
        'likeTo': likeToUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("ユーザー ${likeToUserId} にいいねを送りました");

      _deleteUserFromList(user);
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  Future<void> _deleteUserFromList(NopeUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection('nope')
          .doc(user.nopeDocId)
          .delete();
      print("ユーザー ${user.userId} の左スワイプデータを削除しました");

      setState(() {
        _nopeUsersFuture =
            _nopeUsersFuture.then((users) => users..remove(user));
      });
    } catch (e) {
      print("削除中にエラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('左スワイプしたユーザー'),
      ),
      body: FutureBuilder<List<NopeUser>>(
        future: _nopeUsersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("エラーが発生しました"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("左スワイプしたユーザーがいません"));
          } else {
            final nopeUsers = snapshot.data!;
            return ListView.builder(
              itemCount: nopeUsers.length,
              itemBuilder: (context, index) {
                final nopeUser = nopeUsers[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(nopeUser.name),
                      subtitle: Text('ユーザーID: ${nopeUser.userId}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await _likeUser(nopeUser.userId, nopeUser);
                            },
                            child: const Text('いいね'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              _deleteUserFromList(nopeUser);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('削除'),
                          ),
                        ],
                      ),
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

class NopeUser {
  final String name;
  final int userId;
  final String nopeDocId;

  NopeUser({
    required this.name,
    required this.userId,
    required this.nopeDocId,
  });
}