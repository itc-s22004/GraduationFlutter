import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../utilities/constant.dart';
import 'fullQuestionScreen.dart';

class QuestionScreen extends StatelessWidget {
  late final String question;
  late final String genre;
  late final int userId;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('ユーザー名: ${authController.email.value}', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('questions').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final questions = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final questionData = questions[index].data() as Map<String, dynamic>;
                          final genre = questionData['Genre'] ?? '不明';
                          final question = questionData['question'] ?? 'No Question';
                          final userId = questionData['userId'] ?? 0;
                          final questId = questionData['questId'] ?? 0;

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullQuestionScreen(
                                      question: question,
                                      genre: genre,
                                      userId: userId,
                                      questId: questId,
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(4, 4),
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 10,
                                          ),
                                          BoxShadow(
                                            offset: const Offset(-4, -4),
                                            color: Colors.white.withOpacity(0.8),
                                            blurRadius: 10,
                                          ),
                                        ],
                                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                                        child: FutureBuilder<DocumentSnapshot>(
                                          future: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc("user${userId}")
                                              .get(),
                                          builder: (context, userSnapshot) {
                                            if (!userSnapshot.hasData) {
                                              return const Center(child: CircularProgressIndicator());
                                            }

                                            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                                            final mbti = userData?['diagnosis'] ?? 'NotSet';
                                            final profileImageUrl = 'assets/images/${mbti}.jpg';

                                            return QuestionCard(
                                              question: question,
                                              userId: userId,
                                              profileImageUrl: profileImageUrl,
                                              mbtiType: mbti,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 15,
                                      left: 15,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          genre,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
          child: FloatingActionButton(
            onPressed: () => _showCommentDialog(context),
            backgroundColor: Colors.lightBlueAccent,
            child: const Icon(Icons.comment),
          ),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    String genre = 'pg';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('コメントを追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: genre,
                items: <String>['pg', 'lang'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    genre = newValue;
                  }
                },
              ),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(hintText: 'コメントを入力してください'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () {
                final commentText = _commentController.text;
                if (commentText.isNotEmpty) {
                  _addQuestion(commentText, genre);
                  _commentController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('送信'),
            ),
          ],
        );
      },
    );
  }

  void _addQuestion(String questionText, String genre) async {
    try {
      final questsCollection = FirebaseFirestore.instance.collection('questions');
      final questsCount = (await questsCollection.get()).size + 1;

      await FirebaseFirestore.instance.collection('questions').add({
        'questId': questsCount,
        'userId': Get.find<AuthController>().userId.value,
        'question': questionText,
        'timestamp': FieldValue.serverTimestamp(),
        'Genre': genre,
      });
    } catch (e) {
      print("failed to add question: $e");
    }
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final int userId;
  final String profileImageUrl;
  final String mbtiType;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.userId,
    required this.profileImageUrl,
    required this.mbtiType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int truncateLength = 41;
    final isLongText = question.length > truncateLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(profileImageUrl),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(
              mbtiType,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          question.length > truncateLength ? '${question.substring(0, truncateLength)}...' : question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        if (isLongText)
          GestureDetector(
            onTap: () {
              // 質問の詳細画面に移動する処理
            },
            child: const Text(
              'もっと見る',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),
      ],
    );
  }
}