import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_oneplanet/screens/Account/accountPage.dart';
import 'package:project_oneplanet/screens/Chat%20Rooms/event_chat_room.dart';
import 'Chat Rooms/event_chat_room.dart';
import 'package:project_oneplanet/screens/Map%20_and_Event%20Details/mapScreen.dart';
import 'package:project_oneplanet/screens/homePage.dart';
import 'package:project_oneplanet/screens/New_Post/newPost.dart';
import 'package:project_oneplanet/theme/colors.dart';
import '../apis/apis.dart';
import '../helper/firebase_helper.dart';
import '../models/user_model.dart';
import './Chat Rooms/user_chat_room_list.dart';

class LandingPage extends StatefulWidget {
  final User currentUser;
  const LandingPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  UserModel? currentUserModel;

  Future<void> get() async {
    currentUserModel =
        await FirebaseHelper.getUserModelById(widget.currentUser.uid);
  }

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
        ChatRoomList(),

        ///Account page
        AccountPage(
          currentUser: widget.currentUser,
        ),
      ].elementAt(_bottomNavIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.kDarkGreen,
        child: Icon(
          Icons.add,
          size: 28,
          color: Colors.white,
        ),
        onPressed: () {
          _fabAnimationController.reset();
          _borderRadiusAnimationController.reset();
          _borderRadiusAnimationController.forward();
          _fabAnimationController.forward();
          APIs.getSelfInfo().then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPost(currentUser: APIs.myCurrentUser),
              ),
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? AppColors.kDarkGreen : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? boldIconList[index] : iconList[index],
                size: 24,
                color: color,
              ),
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
