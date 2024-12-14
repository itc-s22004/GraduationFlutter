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
        title: const Text(
            '投稿',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
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
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Text('ユーザー名: ${authController.email.value}', style: const TextStyle(fontSize: 18)),
                //     ],
                //   ),
                // ),
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
                                        //   BoxShadow(
                                        //     offset: const Offset(-4, -4),
                                        //     color: Colors.white.withOpacity(0.8),
                                        //     blurRadius: 10,
                                        //   ),
                                        ],
                                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                            final profileImageUrl = 'assets/images/${mbti}.png';

                                            return QuestionCard(
                                              question: question,
                                              userId: userId,
                                              profileImageUrl: profileImageUrl,
                                              mbtiType: mbti,
                                              genre: genre,
                                            );
                                          },
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
            // backgroundColor: Colors.lightBlueAccent,
            backgroundColor: kQuestBackground,
            child: const Icon(Icons.comment),
          ),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    String genre = 'ジャンル';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Text('何を投稿しますか？', style: TextStyle(fontSize: 21)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: genre,
                      isExpanded: true,
                      items: <String>['ジャンル', 'pg', 'lang'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            genre = newValue;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'ジャンル',
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade50,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: TextField(
                  maxLines: 5,
                  controller: _commentController,
                  onChanged: (value) {
                    setState(() {}); // テキスト変更時に状態を更新
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: (genre == 'pg' || genre == 'lang') && _commentController.text.isNotEmpty
                      ? () {
                    final commentText = _commentController.text;
                    _addQuestion(commentText, genre);
                    _commentController.clear();
                    Navigator.of(context).pop();
                  }
                      : null, // 無効状態の送信ボタン
                  child: const Text('送信'),
                ),
              ],
            );
          },
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
  final String genre;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.userId,
    required this.profileImageUrl,
    required this.mbtiType,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int truncateLength = 41;
    final isLongText = question.length > truncateLength;

    return SingleChildScrollView(  // ここでスクロール可能にする
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(profileImageUrl),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 15),
              Text(
                mbtiType,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(), // アイコンとジャンルを右に寄せる
              Container(
                alignment: Alignment.center,
                height: 35,
                width: 100,
                decoration: BoxDecoration(
                  // color: Colors.lightBlueAccent,
                  color: kQuestBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  genre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 最大3行まで表示し、それを超えると「もっと見る」を表示
          Text(
            question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            maxLines: isLongText ? 3 : null, // 長い場合は最大3行
            overflow: TextOverflow.ellipsis, // テキストが多い場合は省略する
          ),
          const SizedBox(height: 8),
          if (isLongText)
            GestureDetector(
              onTap: () {
                // 質問の詳細画面に移動する処理を追加する
              },
              child: const Text(
                'もっと見る',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}