import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_controller.dart';
import '../comp/detailDesgin.dart';
import '../utilities/constant.dart';

class GroupChatRoom extends StatelessWidget {
  // final int userId;
  // final String mbti;
  final String roomName;

  GroupChatRoom({required this.roomName});

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _numberController = TextEditingController();
  static const double cardSize = 210.0;
  static int senderId = 0;

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          roomName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        .doc(roomName)
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

                          final profileImageUrl = 'assets/images/${messageData['mbti']}.png';

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
                              child: Column(
                                crossAxisAlignment: isCurrentUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (!isCurrentUser)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _showUserInfoPanel(context, messageData['senderId']),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundImage: AssetImage(profileImageUrl),
                                            // backgroundColor: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          messageData['schoolId'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 5),
                                  Text(messageData['message']),
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

  void _showUserInfoPanel(BuildContext context, int senderId) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: senderId)
        .get();
    print("senderId2: ${senderId}");

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
                              context,
                              Icons.person,
                              '性別',
                              userData['gender'],
                              cardSize
                          ),
                          const SizedBox(width: 24),
                          buildInfoCard(
                              context,
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
                            context,
                            Icons.person,
                            'MBTI',
                            userData['diagnosis'],
                            cardSize,
                          ),
                          const SizedBox(width: 24),
                          Builder(
                            builder: (context) {
                              double screenWidth = MediaQuery.of(context).size.width;
                              double photoCardSize = screenWidth * 0.42;
                              if (photoCardSize > 220.0) photoCardSize = 220.0;

                              return Container(
                                width: photoCardSize,
                                height: photoCardSize,
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
                                    "assets/images/${userData['diagnosis']}.png",
                                    width: photoCardSize,
                                    height: photoCardSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      buildIntroductionCard(
                          context,
                          userData['introduction']
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9 > 460
                                  ? 460
                                  : MediaQuery.of(context).size.width * 0.9,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.label, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text(
                                    'タグ:',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: userData['tag']?.map<Widget>((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
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

  Stream<QuerySnapshot> _getMessagesStream(AuthController authController) {
    return FirebaseFirestore.instance
        .collection('groupChatRooms')
        .doc(roomName)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _sendMessage(
      String message, AuthController authController) async {
    final currentUserId = authController.userId.value;
    await FirebaseFirestore.instance
        .collection('groupChatRooms')
        .doc(roomName)
        .collection('messages')
        .add({
      'message': message,
      'senderId': currentUserId,
      'schoolId': authController.schoolNum.value,
      'mbti': authController.diagnosis.value,
      'timestamp': FieldValue.serverTimestamp(),
    });
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