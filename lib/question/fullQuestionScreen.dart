import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../comp/UserDetailsPanel.dart';
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

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    _buildGenreTag(),
                    const SizedBox(height: 16),
                    _buildUserInfo(),
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

  Widget _buildGenreTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        genre,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc('user$userId')
          .get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
        final mbti = userData?['diagnosis'] ?? 'NotSet';
        final profileImageUrl = 'assets/images/${mbti}.jpg';

        // ユーザー情報の準備
        final user = LikeToUser(
          name: userData?['name'] ?? 'Unknown',
          userId: userId,
          likeDocId: '', // 必要に応じて設定
          gender: userData?['gender'] ?? 'NotSet',
          introduction: userData?['introduction'] ?? 'No Introduction',
          mbti: mbti,
          school: userData?['school'] ?? 'Unknown',
          tag: List<String>.from(userData?['tag'] ?? []),
        );

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Allows the panel to be taller than the default
                  backgroundColor: Colors.transparent, // Makes the edges rounded
                  builder: (BuildContext context) {
                    return UserDetailsPanel(
                      user: user,
                      onLikeUser: (int likeToUserId) async {
                        await _likeUser(likeToUserId);
                      },
                      onDeleteUser: (LikeToUser user) async {
                        await _deleteUser(user);
                      },
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(profileImageUrl),
                backgroundColor: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              mbti,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
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

                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final mbti = userData?['diagnosis'] ?? 'NotSet';
                final profileImageUrl = 'assets/images/${mbti}.jpg';

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
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              Text(
                                'MBTI: $mbti',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
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