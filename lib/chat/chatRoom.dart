import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../auth_controller.dart';

class ChatRoom extends StatelessWidget {
  final int userId;
  final String userName;

  ChatRoom({required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
    appBar: AppBar(
    title: Text('チャット - $userName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessagesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text('${messageData['senderId']}に送信'),
                      subtitle: Text(messageData['message']),
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
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: "メッセージを入力..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      _sendMessage(messageController.text);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// メッセージをリアルタイムで取得するためのストリーム
  Stream<QuerySnapshot> _getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// メッセージをFirestoreに送信する関数
  Future<void> _sendMessage(String message) async {
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(_getChatRoomId())
        .collection('messages')
        .add({
      'message': message,
      'senderId': userId, // 送信者のIDを使用
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// チャットルームIDを生成する関数
  /// 例えば、userIdと現在ログインしているユーザーのIDを結合してチャットルームのIDを決定
  String _getChatRoomId() {
    final AuthController authController = Get.find();
    final currentUserId = authController.userId.value;

    return currentUserId < userId
        ? '$currentUserId-$userId'
        : '$userId-$currentUserId';
  }
}


// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//
// String randomString() {
//   final random = Random.secure();
//   final values = List<int>.generate(16, (i) => random.nextInt(255));
//   return base64UrlEncode(values);
// }
//
// class ChatRoom extends StatefulWidget {
//   final int userId;
//   final String userName;
//
//   const ChatRoom({
//     Key? key,
//     required this.userId,   // ユーザーIDを受け取る
//     required this.userName, // ユーザー名を受け取る
//   }) : super(key: key);
//
//   @override
//   ChatRoomState createState() => ChatRoomState();
// }
//
// class ChatRoomState extends State<ChatRoom> {
//   final List<types.Message> _messages = [];
//   final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: Text('${widget.userName}さんとのチャット'), // ユーザー名をタイトルに表示
//     ),
//     body: Chat(
//       user: _user,
//       messages: _messages,
//       onSendPressed: _handleSendPressed,
//     ),
//   );
//
//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }
//
//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: randomString(),
//       text: message.text,
//     );
//
//     _addMessage(textMessage);
//   }
// }
