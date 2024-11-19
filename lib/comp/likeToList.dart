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
            mbti: userData['diagnosis'] ?? 'marmot',
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

  Widget _buildTag(String tag) {
    return Chip(
      label: Text(
        tag,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      backgroundColor: Colors.teal.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  void _showUserDetails(BuildContext context, LikeToUser user) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/${user.mbti}.jpg'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.mbti,
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: user.tags.map((tag) => _buildTag(tag)).toList(),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(Icons.school, "学校", user.school),
                              _buildDetailRow(Icons.abc, "自己紹介", user.introduction),
                            ],
                          ),
                        ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _buildActionBtn(Icons.favorite, "いいね", Colors.blue),
                    //     _buildActionBtn(Icons.cancel, "削除", Colors.red),
                    //   ],
                    // )
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionBtn(
                            Icons.favorite,
                            "いいね",
                            Colors.blue,
                                () async {
                              await _likeUser(user.userId);
                              Navigator.pop(context);
                            }
                        ),
                        _buildActionBtn(
                            Icons.cancel,
                            "削除",
                            Colors.red,
                                () async {
                              await _deleteUser(user);
                              Navigator.pop(context);
                            }
                        ),
                      ],
                    )
                  ],
                )
            ),
          );
        }
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "$title: $detail",
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // Widget _buildActionBtn(IconData icon, String label, Color color) {
  //   return ElevatedButton.icon(
  //     onPressed: () {
  //       if (label == "いいね") {
  //         _likeUser();
  //       }
  //     },
  //     icon: Icon(icon, color: Colors.white),
  //     label: Text(label, style: const TextStyle(color: Colors.white)),
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: color,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //     ),
  //   );
  // }

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
            final user = _likeToUsers[index]; //-----------------
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/${user.mbti}.jpg'),
                backgroundColor: Colors.grey[200],
                radius: 24,
              ),
              title: Text(user.name),
              subtitle: Text('ユーザID: ${user.userId}\nMBTI: ${user.mbti}'),
              onTap: () {
                _showUserDetails(context, user);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _likeUser(user.userId);
                    }, child: const Text('いいね'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _deleteUser(user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                    ),
                    child: const Text('削除'),
                  ),
                ],
              ),
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