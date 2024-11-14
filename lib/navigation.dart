import 'package:flutter/material.dart';
import 'package:omg/chat/chatList.dart';
import 'package:omg/question/questionScreen.dart';
import 'package:omg/setting/setting.dart';
import 'package:omg/with/with.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static final List<Widget> _screens = [
    const MainApp(),
    ChatListScreen(),
    QuestionScreen(),
    SettingScreen()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Question',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
