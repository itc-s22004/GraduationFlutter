import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../comp/UserDetailsPanel.dart';
import '../comp/detailDesgin.dart';
import '../comp/likeToList.dart';
import '../utilities/constant.dart';

class FullQuestionScreen extends StatelessWidget {
  late final String question;
  late final String genre;
  late final int questId;
  late final int userId;
  final TextEditingController _commentController = TextEditingController();

  FullQuestionScreen({
    Key? key,
    required this.question,
    required this.genre,
    required this.questId,
    required this.userId,
  }) : super(key: key);

  static const double cardSize = 210.0;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("返信",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            // 背景のカラー
            Container(
              height: 500,
              color: kAppBtmBackground,
            ),
            // 背景の角丸の白い部分
            Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            // コンテンツ部分
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGenreAndUserRow(),
                    const SizedBox(height: 16),
                    _buildQuestionText(),
                    const SizedBox(height: 32),
                    _buildCommentInput(),
                    const SizedBox(height: 32),
                    _buildCommentsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreAndUserRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc('user$userId')
              .get(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
            final mbti = userData?['diagnosis'] ?? 'NotSet';
            final profileImageUrl = 'assets/images/${mbti}.png';

            return GestureDetector(
              onTap: () {
                // 詳細パネルを開く
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
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
                                        userData?['gender'],
                                        cardSize
                                    ),
                                    const SizedBox(width: 24),
                                    buildInfoCard(
                                        context,
                                        Icons.school,
                                        '学校',
                                        userData?['school'],
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
                                      mbti,
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
                                              "assets/images/${mbti}.png",
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
                                  userData?['introduction']
                                ),
                                const SizedBox(height: 24),
                                Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9 > 460
                                            ? 460
                                            : MediaQuery.of(context).size.width * 0.9,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.start, // 左寄せ
                                          children: [
                                            Icon(Icons.label, color: Colors.green),
                                            SizedBox(width: 8),
                                            Text(
                                              'タグ:',
                                              style: TextStyle(
                                                  fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: 8.0,
                                      runSpacing: 8.0,
                                      children: userData?['tag']?.map<Widget>((tag) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: kObjectBackground,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            tag,
                                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                                          ),
                                        );
                                      }).toList() ??
                                          [],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(profileImageUrl),
                backgroundColor: Colors.grey,
              ),
            );
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            // color: Colors.lightBlueAccent,
            color: kQuestBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            genre,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionText() {
    return Text(
      question,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCommentInput() {
    return TextField(
      maxLines: 2,
      controller: _commentController,
      decoration: InputDecoration(
        hintText: '\nコメントを入力...',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            final commentText = _commentController.text.trim();
            if (commentText.isNotEmpty) {
              _addComment(commentText);
              _commentController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('questId', isEqualTo: questId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('コメントがありません'));
        }

        final comments = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final commentData = comments[index].data() as Map<String, dynamic>;
            final commentText = commentData['comment'] ?? 'No Comment';
            final commenterId = commentData['userId'] ?? 0;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc('user$commenterId')
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;
                final mbti = userData?['diagnosis'] ?? 'NotSet';
                final profileImageUrl = 'assets/images/${mbti}.png';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(profileImageUrl),
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentText,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                              Text(
                                'MBTI: $mbti',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _addComment(String commentText) async {
    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'questId': questId,
        'userId': Get.find<AuthController>().userId.value,
        'comment': commentText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Failed to add comment: $e");
    }
  }

  // Like処理の追加
  Future<void> _likeUser(int likeToUserId) async {
    final authController = Get.find<AuthController>();
    try {
      await FirebaseFirestore.instance.collection('likes').add({
        'likeFrom': authController.userId.value,
        'likeTo': likeToUserId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("User liked successfully");
    } catch (e) {
      print("Failed to like user: $e");
    }
  }

  Future<void> _deleteUser(LikeToUser user) async {
    final authController = Get.find<AuthController>();
    try {
      await FirebaseFirestore.instance.collection('nope2').add({
        'nopeFrom': authController.userId.value,
        'nopeTo': user.userId,
        'timestamp': FieldValue.serverTimestamp()
      });
      print("ユーザー ${user.userId} の左スワイプデータを削除しました");
    } catch (e) {
      print("削除中にエラーが発生しました: $e");
    }
  }
}
