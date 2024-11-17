import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import 'fullQuestionScreen.dart';

class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('質問一覧'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              final userId = int.tryParse(questionData['userId'].toString()) ?? 0;

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
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 180,
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
                            child: QuestionCard(question: question, userId: userId),
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
    );
  }
}

class QuestionCard extends StatelessWidget {
  final String question;
  final int userId;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int truncateLength = 41;
    final isLongText = question.length > truncateLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.length > truncateLength ? '${question.substring(0, truncateLength)}...' : question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'ユーザーID: $userId',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
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