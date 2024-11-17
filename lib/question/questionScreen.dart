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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('question一覧'),
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
                    // Navigate to FullQuestionScreen with question details
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
                          width: 450,
                          decoration: BoxDecoration(
                            color: Colors.lime,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(10, 10),
                                color: Theme.of(context).scaffoldBackgroundColor,
                                blurRadius: 20,
                              ),
                              BoxShadow(
                                offset: const Offset(-10, -10),
                                color: Theme.of(context).scaffoldBackgroundColor,
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60, left: 10),
                            child: QuestionCard(question: question, userId: userId),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 0,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                              ),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.length > truncateLength ? '${question.substring(0, truncateLength)}...' : question,
            style: const TextStyle(fontSize: 20),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            'ユーザーID: $userId',
            style: const TextStyle(fontSize: 14),
          ),
          if (isLongText)
            const Text(
              'もっと見る',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
        ],
      ),
    );
  }
}