import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:omg/auth_controller.dart';

import '../utilities/constant.dart';
import 'detailDesgin.dart';

class NopeList extends StatefulWidget {
  final int currentUserId;

  const NopeList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _NopeListState createState() => _NopeListState();
}

class _NopeListState extends State<NopeList> {
  late Future<List<NopeUser>> _nopeUsersFuture;
  static const double cardSize = 210.0;

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
            mbti: userData['diagnosis'] ?? 'marmot',
            school: userData['school'] ?? '未設定',
            tags: List<String>.from(userData['tag'] ?? []),
          ));
        } else {
          print("User with ID $nopeToUserId not found.");
        }
      }
    } catch (e) {
      print("エラーが発生しました: $e");
    }
    return nopeUsers;
  }


  Future<void> _likeUser(int likeToUserId, NopeUser user) async {
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

    print("user.introduction: ${user.introduction}");
    print("user.tags: ${user.tags}");

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
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 20.0, left: 10.0),
                child: Column(
                  children: [  // -----------------------プロフィールのデザイン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildInfoCard(
                            context,
                            Icons.person,
                            '性別',
                            user.gender,
                            cardSize
                        ),
                        const SizedBox(width: 24),
                        buildInfoCard(
                            context,
                            Icons.school,
                            '学校',
                            user.school,
                            cardSize
                        ),
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
                                  "assets/images/${user.mbti}.png",
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
                    buildIntroductionCard(
                      context,
                        user.introduction
                    ),
                    const SizedBox(height: 24),
                    buildTagsSection(context, user.tags)
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
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NOTした人',
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
            FutureBuilder<List<NopeUser>>(
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
                  return ListView.separated(
                    itemCount: nopeUsers.length,
                    itemBuilder: (context, index) {
                      final user = nopeUsers[index];
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
                                AssetImage('assets/images/${user.mbti}.png'),
                                backgroundColor: Colors.grey[200],
                                radius: 35, // 写真のサイズ
                              ),
                              const SizedBox(width: 20.0), // 写真とテキストの間
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   user.name,
                                    //   style: const TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // const SizedBox(height: 4.0),
                                    // Text(
                                    //   'ユーザID: ${user.userId}',
                                    //   style: const TextStyle(
                                    //       fontSize: 14, color: Colors.grey),
                                    // ),
                                    // const SizedBox(height: 4.0),
                                    Text(
                                      '${user.mbti}',
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _likeUser(user.userId, user);
                                    },
                                    child: const Text('いいね'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _deleteUserFromList(user.userId, user);
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
                }
              },
            ),
          ],
        ),
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