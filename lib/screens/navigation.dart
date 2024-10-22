import 'package:flutter/material.dart';
import 'package:omg/screens/chatList.dart';
import 'package:omg/screens/setting.dart';
import 'package:omg/with.dart';

// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({super.key});
//
//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }
//
// class _BottomNavigationState extends State<BottomNavigation> {
//   // 各画面のリスト
//   static const _screens = [
//     MainApp(),             // メイン画面（スワイプ機能）
//     ChatListScreen(),       // チャット一覧画面
//     SettingScreen(),        // 設定画面
//   ];
//
//   // 選択されている画面のインデックス
//   int _selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],  // インデックスに基づいて画面を表示
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             _selectedIndex = index;  // タップされたタブのインデックスを設定
//           });
//         },
//         selectedIndex: _selectedIndex,  // 現在選択されているタブ
//         destinations: const <NavigationDestination>[
//           NavigationDestination(
//             selectedIcon: Icon(Icons.home),
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.chat),
//             label: 'Chat',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  static const List<Widget> _screens = [
    MainApp(),
    ChatListScreen(),
    SettingScreen(),
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
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
