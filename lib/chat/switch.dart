import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omg/auth_controller.dart';
import 'package:omg/chat/chatList.dart';
import 'package:omg/chat/groupChatList.dart';
import '../utilities/constant.dart';

class SwitchScreen extends StatefulWidget {
  @override
  _SwitchScreenState createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'チャット',
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: kAppBtmBackground,
          ),
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(200),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          // TabBarを透明にして重ねる
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.pinkAccent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.withOpacity(0.6),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),  // ここで文字を太く設定
                tabs: const [
                  Tab(text: '個人',),
                  Tab(text: 'グループ'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            bottom: 0,
            child: TabBarView(
              controller: _tabController,
              children: [
                ChatListScreen(),
                GroupChatList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
