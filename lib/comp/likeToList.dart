import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/constant.dart';
import 'UserDetailsPanel.dart';
import 'detailDesgin.dart';

class LikeToList extends StatefulWidget {
  final int currentUserId;

  const LikeToList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _LikeToListState createState() => _LikeToListState();
}

class _LikeToListState extends State<LikeToList> {
  final RxList<LikeToUser> _likeToUsers = <LikeToUser>[].obs;
  static const double cardSize = 210.0;

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
            tag: List<String>.from(userData['tag'] ?? []),
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
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0),
                child: Column(
                  children: [
                    // -----------------------プロフィールのデザイン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildInfoCard(
                            context, Icons.person, '性別', user.gender, cardSize),
                        const SizedBox(width: 24),
                        buildInfoCard(
                            context, Icons.school, '学校', user.school, cardSize),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildInfoCard(
                          context,
                          Icons.person,
                          'MBTI',
                          user.mbti,
                          cardSize,
                        ),
                        const SizedBox(width: 24),
                        Builder(
                          builder: (context) {
                            double screenWidth = MediaQuery.of(context).size.width;
                            double photoCardSize = screenWidth * 0.42;
                            if (photoCardSize > 220.0) photoCardSize = 220.0;

                            return Container(
                              width: photoCardSize,
                              height: photoCardSize,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  "assets/images/${user.mbti}.jpg",
                                  width: photoCardSize,
                                  height: photoCardSize,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    buildIntroductionCard(context, user.introduction),
                    const SizedBox(height: 24),
                    buildTagsSection(context, user.tag)
                  ],
                ),
              ),
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
        title: const Text(
          'LIKEしてくれた人',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(90, 30),
          ),
        ),
        backgroundColor: kAppBarBackground,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            Container(
              height: 500,
              color: kAppBtmBackground,
            ),
            Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Obx(() {
              if (_likeToUsers.isEmpty) {
                return const Center(child: Text("あなたをLIKEしたユーザーがいません"));
              }
              return ListView.separated(
                itemCount: _likeToUsers.length,
                itemBuilder: (context, index) {
                  final user = _likeToUsers[index];
                  return InkWell(
                    onTap: () {
                      _showUserDetails(context, user);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/${user.mbti}.jpg'),
                            backgroundColor: Colors.grey[200],
                            radius: 35, // 写真のサイズ
                          ),
                          const SizedBox(width: 20.0), // 写真とテキストの間
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'ユーザID: ${user.userId}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'MBTI: ${user.mbti}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  await _likeUser(user.userId);
                                },
                                child: const Text('いいね'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _deleteUser(user);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text('削除'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }),
          ],
        ),
      ),
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
  final List<String> tag;

  LikeToUser({
    required this.name,
    required this.userId,
    required this.likeDocId,
    required this.gender,
    required this.introduction,
    required this.mbti,
    required this.school,
    required this.tag,
  });
}
