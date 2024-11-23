import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class FullQuestionScreen extends StatelessWidget {
  final String question;
  final String genre;
  final int questId;
  final int userId;
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
        title: const Text('質問詳細'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
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

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(profileImageUrl),
              backgroundColor: Colors.grey,
              // child: const Icon(Icons.person, color: Colors.white),
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
      controller: _commentController,
      decoration: InputDecoration(
        hintText: 'コメントを入力...',
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
                          // child: const Icon(Icons.person, color: Colors.white),
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
}