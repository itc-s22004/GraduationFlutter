import 'package:flutter/material.dart';
import 'package:omg/chat/chatList.dart';
import 'package:omg/question/questionScreen.dart';
import 'package:omg/setting/setting.dart';
import 'package:omg/utilities/constant.dart';
import 'package:omg/utilities/icon_path_util.dart';
import 'package:omg/with/with.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  PersistentTabController? _controller;
  int? selectedIndex;

  @override
  void initState() {
    _controller = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PersistentTabView(
          context,
          controller: _controller,
          navBarHeight: kSizeBottomNavigationBarHeight,
          screens: _buildScreens(),
          items: _navBarsItems(),
          backgroundColor: kColorBNBBackground,
          // エラーの出るプロパティは削除
          handleAndroidBackButtonPress: true,
          stateManagement: true,
          // navBarStyle: NavBarStyle.style6, // NavBarStyleは変更できる場合があります
            navBarStyle: NavBarStyle.style19,
            onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }


  List<Widget> _buildScreens() {
    return [
      const MainApp(),
      ChatListScreen(),
      QuestionScreen(),
      SettingScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarHome,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarHomeDeactive,
              ),
            ),
          ],
        ),
        title: ('Home'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarAnimals,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarAnimalsDeactive,
              ),
            ),
          ],
        ),
        title: ('Animals'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarPlants,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarPlantsDeactive,
              ),
            ),
          ],
        ),
        title: ('Plants'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarProfile,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarProfileDeactive,
              ),
            ),
          ],
        ),
        title: ('Profile'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
    ];
  }
}

// import 'package:flutter/material.dart';
// import 'package:omg/chat/chatList.dart';
// import 'package:omg/question/questionScreen.dart';
// import 'package:omg/setting/setting.dart';
// import 'package:omg/with/with.dart';
//
// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({super.key});
//
//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }
//
// class _BottomNavigationState extends State<BottomNavigation> {
//   static final List<Widget> _screens = [
//     const MainApp(),
//     ChatListScreen(),
//     QuestionScreen(),
//     SettingScreen()
//   ];
//
//   int _selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: NavigationBar(
//         onDestinationSelected: (int index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         indicatorColor: Colors.amber,
//         selectedIndex: _selectedIndex,
//         destinations: const <Widget>[
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
//             icon: Icon(Icons.account_balance_wallet),
//             label: 'Question',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.account_circle),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }