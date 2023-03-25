import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_oneplanet/screens/accountPage.dart';
import 'package:project_oneplanet/screens/chatPage.dart';
import 'package:project_oneplanet/screens/homePage.dart';
import 'package:project_oneplanet/screens/mapPage.dart';
import 'package:project_oneplanet/screens/newPost.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = [
    CupertinoIcons.home,
    CupertinoIcons.map,
    CupertinoIcons.chat_bubble_text,
    CupertinoIcons.person
  ];

  final boldIconList = [
    CupertinoIcons.house_fill,
    CupertinoIcons.map_fill,
    CupertinoIcons.chat_bubble_text_fill,
    CupertinoIcons.person_fill
  ];

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: <Widget>[
        ///Home Page
        HomeScreen(),

        ///Map Page
        MapScreen(),

        ///Chat Page
        ChatScreen(),

        ///Account page
        AccountPage(),
      ].elementAt(_bottomNavIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          CupertinoIcons.add,
          size: 26,
          color: Colors.grey,
        ),
        onPressed: () {
          _fabAnimationController.reset();
          _borderRadiusAnimationController.reset();
          _borderRadiusAnimationController.forward();
          _fabAnimationController.forward();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewPost(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.green : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? boldIconList[index]:iconList[index],
                size: 24,
                color: color,
              ),
              // const SizedBox(height: 4),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Text(
              //     "brightness $index",
              //     maxLines: 1,
              //     style: TextStyle(color: Colors.black),
              //   ),
              // )
            ],
          );
        },
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: Colors.lightGreen,
        notchAndCornersAnimation: borderRadiusAnimation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        hideAnimationController: _hideBottomBarAnimationController,
        shadow: BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
          color: Colors.lightGreen,
        ),
      ),
    );
  }
}
