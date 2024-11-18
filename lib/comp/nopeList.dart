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
            gender: userData['gender'] ?? '未設定',
            introduction: userData['introduction'] ?? '未設定',
            mbti: userData['mbti'] ?? '未設定',
            school: userData['school'] ?? '未設定',
            tags: List<String>.from(userData['tags'] ?? []),
          ));
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
    return nopeUsers;
  }

  Future<void> _likeUser(int likeToUserId, NopeUser user) async { //-----
    try {
      await FirebaseFirestore.instance.collection('likes').add({
        'likeFrom': widget.currentUserId,
        'likeTo': likeToUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("ユーザー ${likeToUserId} にいいねを送りました");

      // _deleteUserFromList(user);
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
      print("エラーが発生しました: $e");
    }
  }

  Future<void> _deleteUserFromList(int nopeToUserId, NopeUser user) async {
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

      await FirebaseFirestore.instance.collection('nope2').add({
        'nopeFrom': widget.currentUserId,
        'nopeTo': nopeToUserId,
        'timestamp': FieldValue.serverTimestamp()
      });
      print("ユーザ${user.userId}をnope２に入れました。");
    } catch (e) {
      print("削除中にエラーが発生しました: $e");
    }
  }

  void _showUserDetails(BuildContext context, NopeUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          widthFactor: 0.9,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('名前: ${user.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('ユーザーID: ${user.userId}'),
                const SizedBox(height: 10),
                Text('性別: ${user.gender}'),
                const SizedBox(height: 10),
                Text('自己紹介: ${user.introduction}'),
                const SizedBox(height: 10),
                Text('MBTI: ${user.mbti}'),
                const SizedBox(height: 10),
                Text('学校: ${user.school}'),
                const SizedBox(height: 10),
                Text('タグ: ${user.tags.join(', ')}'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _likeUser(user.userId, user);
                        Navigator.of(context).pop();
                      },
                      child: const Text('いいね'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _deleteUserFromList(user.userId, user);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                      onTap: () {
                        _showUserDetails(context, nopeUser);
                      },
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
                              _deleteUserFromList(nopeUser.userId, nopeUser);
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
  final String gender;
  final String introduction;
  final String mbti;
  final String school;
  final List<String> tags;

  NopeUser({
    required this.name,
    required this.userId,
    required this.nopeDocId,
    required this.gender,
    required this.introduction,
    required this.mbti,
    required this.school,
    required this.tags,
  });
}