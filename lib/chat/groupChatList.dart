import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/chat/groupChatRoom.dart';
import '../utilities/constant.dart';

class GroupChatList extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  Future<void> _createChatRoomDocument(String chatRoomId) async {
    if (chatRoomId.isEmpty) return;

    try {
      final chatRoomRef = FirebaseFirestore.instance
          .collection('groupChatRooms')
          .doc(chatRoomId);

      final snapshot = await chatRoomRef.get();
      if (!snapshot.exists) {
        await chatRoomRef.set({
          'createdAt': FieldValue.serverTimestamp(),
        });
        debugPrint("チャットルームが作成されました: $chatRoomId");
      } else {
        debugPrint("既に存在するチャットルーム: $chatRoomId");
      }
    } catch (e) {
      debugPrint("チャットルーム作成中にエラーが発生しました: $e");
    }
  }

  void _showChatRoomDialog(BuildContext context) {
    final TextEditingController chatRoomController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("チャットルームを作成"),
        content: TextField(
          controller: chatRoomController,
          decoration: const InputDecoration(hintText: "チャットルーム名を入力してください"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("キャンセル"),
          ),
          TextButton(
            onPressed: () {
              final chatRoomId = chatRoomController.text.trim();
              _createChatRoomDocument(chatRoomId);
              Navigator.of(context).pop();
            },
            child: const Text("作成"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("authController.schoolNum.value: ${authController.schoolNum.value}");

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            // 背景色の部分
            Container(
              height: 500,
              color: kAppBtmBackground,
            ),
            Positioned(
              top: -50,
              left: 0,
              right: 0,
              child: Container(
                height: 1000,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groupChatRooms')
                  .snapshots(), // リアルタイムで更新
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("エラーが発生しました"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("チャットルームがありません"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final chatRoom = snapshot.data!.docs[index];
                    final chatRoomName = chatRoom.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                        color: kObjectBackground,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            chatRoomName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.green[700],
                              ),
                              const SizedBox(width: 20.0),
                            ],
                          ),
                          onTap: () {
                            debugPrint("チャットルーム $chatRoomName を選択しました");
                            Get.to(() => GroupChatRoom(roomName: chatRoomName));
                          },
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () => _showChatRoomDialog(context),
          backgroundColor: kQuestBackground,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
