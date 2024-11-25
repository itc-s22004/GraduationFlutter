import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';

class ChatRoom extends StatelessWidget {
  final int userId;
  final String userName;
  final String mbti;

  ChatRoom({required this.userId, required this.userName, required this.mbti});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('チャット - $userName'),
      ),
      body: Column(
        children: [
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
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
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
                            Flexible(
                              child: Text(messageData['message']),
                            ),
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
                Expanded(
                  child: TextField(
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

              // mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // children: [
              //   Text('ユーザー情報', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              //   SizedBox(height: 10),
              //   Text('診断: ${userData['diagnosis']}'),
              //   Text('メール: ${userData['email']}'),
              //   Text('性別: ${userData['gender']}'),
              //   Text('学校: ${userData['school']}'),
              //   Text('自己紹介: ${userData['introduction']}'),
              //   SizedBox(height: 10),
              //   Text('タグ: ${userData['tag']?.join(', ')}'),
              // ],
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