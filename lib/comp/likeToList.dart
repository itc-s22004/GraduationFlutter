import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeToList extends StatefulWidget {
  final int currentUserId;

  const LikeToList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _LikeToListState createState() => _LikeToListState();
}

class _LikeToListState extends State<LikeToList> {
  final RxList<LikeToUser> _likeToUsers = <LikeToUser>[].obs;

  @override
  void initState() {
    super.initState();
    _fetchLikeToUsers();
  }

  Future<void> _fetchLikeToUsers() async {
    try {
      final likeToUsers = <LikeToUser>[];
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
            gender: userData['gender'] ?? '未設定',
            introduction: userData['introduction'] ?? '未設定',
            mbti: userData['mbti'] ?? '未設定',
            school: userData['school'] ?? '未設定',
            tags: List<String>.from(userData['tags'] ?? []),
          ));
        }
      }

      _likeToUsers.assignAll(likeToUsers);
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  Future<void> _deleteUser(LikeToUser user) async {
    try {
      await FirebaseFirestore.instance
          .collection('likes')
          .doc(user.likeDocId)
          .delete();

      print("ユーザー ${user.userId} の左スワイプデータを削除しました");

      _likeToUsers.remove(user);
    } catch (e) {
      print("削除中にエラーが発生しました: $e");
    }
  }

  void _showUserDetails(BuildContext context, LikeToUser user) {
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('ユーザーID: ${user.userId}'),
                  const SizedBox(height: 20),
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
                          await _likeUser(user.userId);
                          Navigator.pop(context);
                        },
                        child: const Text('いいね'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _deleteUser(user);
                          Navigator.pop(context);
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
          ),
        );
      },
    );
  }

  Future<void> _likeUser(int likeToUserId) async {
    try {
      final likeCollection = FirebaseFirestore.instance.collection('likes');

      await FirebaseFirestore.instance.collection('likes').add({
        'likeFrom': widget.currentUserId,
        'likeTo': likeToUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("ユーザー ${likeToUserId} にいいねを送りました");

      final reverseLikeSnapshot = await likeCollection
          .where('likeFrom', isEqualTo: likeToUserId)
          .where('likeTo', isEqualTo: widget.currentUserId)
          .get();

      if (reverseLikeSnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance.collection('matches').add({
          'user1': widget.currentUserId,
          'user2': likeToUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("マッチングしました: ${widget.currentUserId} と $likeToUserId");

        for (var doc in reverseLikeSnapshot.docs) {
          await likeCollection.doc(doc.id).delete();
        }

        final userLikeSnapshot = await likeCollection
            .where('likeFrom', isEqualTo: widget.currentUserId)
            .where('likeTo', isEqualTo: likeToUserId)
            .get();
        for (var doc in userLikeSnapshot.docs) {
          await likeCollection.doc(doc.id).delete();
        }

        _likeToUsers.removeWhere((user) => user.userId == likeToUserId);
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('あなたをLIKEしたユーザー'),
      ),
      body: Obx(() {
        if (_likeToUsers.isEmpty) {
          return const Center(child: Text("あなたをLIKEしたユーザーがいません"));
        }
        return ListView.builder(
          itemCount: _likeToUsers.length,
          itemBuilder: (context, index) {
            final likeToUser = _likeToUsers[index];
            return Column(
              children: [
                ListTile(
                  title: Text(likeToUser.name),
                  subtitle: Text('ユーザーID: ${likeToUser.userId}'),
                  onTap: () {
                    _showUserDetails(context, likeToUser);
                  },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _likeUser(likeToUser.userId);
                          },
                          child: const Text('いいね'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            _deleteUser(likeToUser);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('削除'),
                        ),
                      ],
                    )
                ),
                const Divider(),
              ],
            );
          },
        );
      }),
    );
  }
}

class LikeToUser {
  final String name;
  final int userId;
  final String likeDocId;
  final String gender;
  final String introduction;
  final String mbti;
  final String school;
  final List<String> tags;

  LikeToUser({
    required this.name,
    required this.userId,
    required this.likeDocId,
    required this.gender,
    required this.introduction,
    required this.mbti,
    required this.school,
    required this.tags,
  });
}