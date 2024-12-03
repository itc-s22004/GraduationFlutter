import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../comp/detailDesgin.dart';
import '../utilities/constant.dart';

class ChatRoom extends StatelessWidget {
  final int userId;
  final String userName;
  final String mbti;

  ChatRoom({required this.userId, required this.userName, required this.mbti});

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _numberController = TextEditingController();
  static const double cardSize = 210.0;

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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        number1,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                          final messageData =
                              messages[index].data() as Map<String, dynamic>;
                          final bool isCurrentUser = messageData['senderId'] ==
                              authController.userId.value;
                          final profileImageUrl = 'assets/images/$mbti.jpg';

                          return Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isCurrentUser
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
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
                                        backgroundImage:
                                            AssetImage(profileImageUrl),
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
                        onPressed: () =>
                            _showMyNumDialog(context, authController),
                      ),
                      Expanded(
                        child: TextField(
                          maxLines: 2,
                          // minLines: 1,
                          controller: messageController,
                          decoration:
                              const InputDecoration(hintText: "\nメッセージを入力..."),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            _sendMessage(
                                messageController.text, authController);
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildInfoCard(
                              Icons.person,
                              '性別',
                              userData['gender'],
                              cardSize
                          ),
                          const SizedBox(width: 24),
                          buildInfoCard(
                              Icons.school,
                              '学校',
                              userData['school'],
                              cardSize
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildInfoCard(
                              Icons.person,
                              'MBTI',
                              userData['diagnosis'],
                              cardSize
                          ),
                          const SizedBox(width: 24),
                          Container(
                            width: cardSize,
                            height: cardSize,
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
                                "assets/images/${userData['diagnosis']}.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      buildIntroductionCard(
                          userData['introduction']
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.label, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'タグ:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 360),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: userData['tag']?.map<Widget>((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
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
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87),
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
    }
  }

  void _showMyNumDialog(BuildContext context, AuthController authController) async {
    String course = '学科を選んで'; // 初期値は「学科を選んで」
    final chatRoomRef = FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId(authController))
        .collection('number');

    final snapshot = await chatRoomRef.get();

    bool showDialogFlag = true;

    for (var doc in snapshot.docs) {
      int senderId = doc['senderId'];

      print('ログイン中のID: ${authController.userId.value}');
      print('Sender ID: $senderId');

      if (authController.userId.value == senderId) {
        print('既に番号が登録されています。');
        showDialogFlag = false;

        _showMatchNotification({
          'email': authController.email.value,
        }, false);
        break;
      }
    }

    if (!showDialogFlag) {
      return;
    }

    // ダイアログ表示
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Center(
                child: Text('自分の番号を入れて！！'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          value: course,
                          items: ['学科を選んで', 's', 'n', 'c'].map((String value) {
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
                                course = newValue; // 新しい選択肢を`course`にセット
                                print("Selected course: $course"); // デバッグ出力
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: '学科',
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
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _numberController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: '例: s22004 -> 「 22004 」',
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    final myId = course + _numberController.text;
                    print("myId: $myId");
                    if (myId != '学科を選んで' && myId.isNotEmpty) {
                      _sendMyNum(myId, authController);
                      _numberController.clear();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('送信'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Stream<QuerySnapshot> _getMessagesStream(AuthController authController) {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId(authController))
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _sendMessage(
      String message, AuthController authController) async {
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
    print("_sendMyNum: ${num}");

    // `users` コレクションから `schoolNumber` と一致するユーザーを検索
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('schoolNumber', isEqualTo: num) // 入力された num が schoolNumber と一致するかを確認
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // 取得したユーザーデータ
      final userData = userSnapshot.docs.first.data();
      final senderId = userData['id']; // `users` コレクションの `id` を取得
      final schoolNumberFromUser =
          userData['schoolNumber']; // `schoolNumber` を取得

      // `currentUserId` と `senderId`、`num` と `schoolNumberFromUser` が一致する場合に登録
      if (currentUserId == senderId && num == schoolNumberFromUser) {
        // 登録処理
        await chatRoomRef.add({
          'number': num,
          'senderId': currentUserId,
          'timestamp': FieldValue.serverTimestamp(),
          'userBool': true,
        });
        _showMatchNotification(userData, true); // ----------------
        print("登録成功: currentUserId と senderId と schoolNumber が一致しました");
      } else {
        print("一致するデータが見つかりませんでした");
      }
    } else {
      print("ユーザーが見つかりませんでした");
    }
  }

// マッチングしたユーザーの情報を表示する通知
  void _showMatchNotification(Map<String, dynamic> userData, bool registratBool) {
    Get.snackbar(
      registratBool
          ? '一致したユーザーが見つかりました！'
          : '自分の番号を登録済みです。',
      'ユーザー: ${userData['email']} さん',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      mainButton: TextButton(
        onPressed: () {
          // 詳細情報を見るアクションを実装する（例: プロフィール画面への遷移）
        },
        child: const Text('詳細を見る', style: TextStyle(color: Colors.white)),
      ),
    );
  }


  String _getChatRoomId(AuthController authController) {
    final currentUserId = authController.userId.value;
    return currentUserId < userId
        ? '$currentUserId-$userId'
        : '$userId-$currentUserId';
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