import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class FullQuestionScreen extends StatelessWidget {
  late final String question;
  late final String genre;
  late final int questId;
  final TextEditingController _commentController = TextEditingController();

   FullQuestionScreen({
    Key? key,
    required this.question,
    required this.genre,
    required this.questId, required userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentUserId = authController.userId.value;

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
              Container(
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
              ),
              const SizedBox(height: 16),
              Text(
                question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
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
              ),

              const SizedBox(height: 32),
              const Text(
                'コメント',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              StreamBuilder<QuerySnapshot>(
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
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentData = comments[index].data() as Map<String, dynamic>;
                      final commentText = commentData['comment'] ?? 'No Comment';
                      final commenterId = commentData['userId'] ?? '不明';

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'コメント: $commentText',
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '投稿者ID: $commenterId',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        await FirebaseFirestore.instance.collection('comments').add({
          'questId': questId,
          'userId': Get.find<AuthController>().userId.value,
          'comment': commentText,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Comment added successfully!");
      }
    } catch (e) {
      print("Failed to add comment: $e");
    }
  }
}