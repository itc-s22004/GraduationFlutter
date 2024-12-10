import 'package:flutter/material.dart';
import 'package:omg/chat/chatList.dart';
import 'package:omg/comp/switch.dart';
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
          handleAndroidBackButtonPress: true,
          stateManagement: true,
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
      SwitchScreen(),
      QuestionScreen(),
      SettingScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarHome,
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarHomeDeactive,
                ),
              ),
            ],
          ),
        ),
        title: ('Home'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarAnimals,
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarAnimalsDeactive,
                ),
              ),
            ],
          ),
        ),
        title: ('Animals'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarPlants,
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarPlantsDeactive,
                ),
              ),
            ],
          ),
        ),
        title: ('Plants'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarProfile,
                ),
              ),
            ],
          ),
        ),
        inactiveIcon: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: kSizeBottomNavigationBarIconHeight,
                child: Image.asset(
                  kIconPathBottomNavigationBarProfileDeactive,
                ),
              ),
            ],
          ),
        ),
        title: ('Profile'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
    ];
  }
}