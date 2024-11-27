import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../utilities/constant.dart';

class ChatRoom extends StatelessWidget {
  final int userId;
  final String userName;
  final String mbti;

  ChatRoom({required this.userId, required this.userName, required this.mbti});

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ChatRoom',
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
            Column(
              children: [
                // Numberカード表示部分
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatRooms')
                        .doc(_getChatRoomId(authController))
                        .collection('number')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final numberDocs = snapshot.data!.docs;

                      // もし2つのnumberが存在する場合
                      if (numberDocs.length >= 2) {
                        final number1 = numberDocs[0]['number'];
                        final number2 = numberDocs[1]['number'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        number1,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 18),
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 18),
                                      Text(
                                        number2,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getMessagesStream(authController),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!.docs.reversed.toList();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final messageData = messages[index].data() as Map<String, dynamic>;
                          final bool isCurrentUser = messageData['senderId'] == authController.userId.value;
                          final profileImageUrl = 'assets/images/$mbti.jpg';

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!isCurrentUser)
                                    GestureDetector(
                                      onTap: () => _showUserInfoPanel(context),
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: AssetImage(profileImageUrl),
                                        backgroundColor: Colors.grey,
                                      ),
                                    ),
                                  if (!isCurrentUser) const SizedBox(width: 8),
                                  Flexible(child: Text(messageData['message'])),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.account_box_outlined),
                        onPressed: () => _showMyNumDialog(context, authController),
                      ),
                      Expanded(
                        child: TextField(
                          maxLines: 2,
                          controller: messageController,
                          decoration: const InputDecoration(hintText: "メッセージを入力..."),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            _sendMessage(messageController.text, authController);
                            messageController.clear();
                            _scrollToBottom();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUserInfoPanel(BuildContext context) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data();

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
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
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/${userData['diagnosis']}.jpg'),
                ),
                const SizedBox(height: 12),
                Text(
                  userData['email'],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData['diagnosis'],
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: userData['tag']?.map<Widget>((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue.shade100,
                    );
                  }).toList() ?? [],
                ),

                const SizedBox(height: 20),

                Expanded(child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(Icons.school, "学校", userData['school']),
                      _buildDetailRow(Icons.abc, "自己紹介", userData['introduction']),
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildDetailRow(IconData icon, String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "$title: $detail",
              style: const TextStyle(fontSize: 16),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showMyNumDialog(BuildContext context, AuthController authController) async {
    final AuthController authController = Get.find<AuthController>();
    String course = '学科を選んで';
    int senderId = 0;

    final chatRoomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId(authController))
        .collection('number');
    final snapshot = await chatRoomRef.get();
    for (var doc in snapshot.docs) {
      senderId = doc['senderId'];  // senderId は数値型
      print('Sender ID: $senderId');
    }


    // `authController.userId` と `senderId` を比較
    if (authController.userId.value == senderId) {
      // もし userId と senderId が同じなら、ダイアログを表示しない
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('自分の番号を入れて！！'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: course,
                      items: <String>['学科を選んで', 's', 'n', 'c'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            course = newValue;
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: _numberController,
                      decoration: const InputDecoration(hintText: '例: s22004 -> 「 22004 」'),
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('キャンセル')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        final myId = course + _numberController.text;
                        if (myId.isNotEmpty) {
                          _sendMyNum(myId, authController);
                          _numberController.clear();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('送信'))
                ],
              );
            },
          );
        });
  }

  Stream<QuerySnapshot> _getMessagesStream(AuthController authController) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId(authController))
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _sendMessage(String message, AuthController authController) async {
    final currentUserId = authController.userId.value;
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId(authController))
        .collection('messages')
        .add({
      'message': message,
      'senderId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _sendMyNum(String num, AuthController authController) async {
    final currentUserId = authController.userId.value;
    final chatRoomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId(authController))
        .collection('number');

    // `users` コレクションから `schoolNumber` と一致するユーザーを検索
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('schoolNumber', isEqualTo: num)  // 入力された num が schoolNumber と一致するかを確認
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // 取得したユーザーデータ
      final userData = userSnapshot.docs.first.data();
      final senderId = userData['id'];  // `users` コレクションの `id` を取得
      final schoolNumberFromUser = userData['schoolNumber'];  // `schoolNumber` を取得

      // `currentUserId` と `senderId`、`num` と `schoolNumberFromUser` が一致する場合に登録
      if (currentUserId == senderId && num == schoolNumberFromUser) {
        // 登録処理
        await chatRoomRef.add({
          'number': num,
          'senderId': currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
          'userBool': true,
        });
        print("登録成功: currentUserId と senderId と schoolNumber が一致しました");
      } else {
        print("一致するデータが見つかりませんでした");
      }
    } else {
      print("ユーザーが見つかりませんでした");
    }
  }

// マッチングしたユーザーの情報を表示する通知
  void _showMatchNotification(Map<String, dynamic> userData) {
    Get.snackbar(
      '一致したユーザーが見つかりました！',
      'ユーザー: ${userData['email']} さん',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          // ここに詳細情報を見るアクションを実装する（例: プロフィール画面への遷移）
        },
        child: const Text('詳細を見る', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  String _getChatRoomId(AuthController authController) {
    final currentUserId = authController.userId.value;
    return currentUserId < userId ? '$currentUserId-$userId' : '$userId-$currentUserId';
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}