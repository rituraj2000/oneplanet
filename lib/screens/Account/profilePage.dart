import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:project_oneplanet/helper/firebase_helper.dart';
import 'package:project_oneplanet/theme/colors.dart';
import 'package:rive/rive.dart';

import '../../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int points = 20;

  Artboard? _riveArtboard;
  SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/riveanimation/tree_demo.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
        _progress = controller.findInput('input');
        setState(() {
          _riveArtboard = artboard;
          _progress?.value = points.toDouble();
        });
      }
    });

    FirebaseHelper.getUserModelById(widget.userId).then((value) {
      String currentPoint = value!.points ?? "";
      setState(() {
        if (currentPoint.isNotEmpty) {
          _progress?.value = int.parse(currentPoint).toDouble();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "User Profile",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontSize: 24,color: AppColors.kDarkGreen),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 15),
              child: FutureBuilder(
                  future: FirebaseHelper.getUserModelById(widget.userId),
                  builder: (ctx, userData) {
                    if (userData.connectionState == ConnectionState.done) {
                      UserModel targetUser = userData.data as UserModel;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            width: 0.22 * screenWidth,
                            height: 0.22 * screenWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(0.11 * screenWidth),
                              color: AppColors.kGreenYellow,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: targetUser.photo ??
                                  "https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            width: 0.64 * screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  targetUser.name ?? "Namrata",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontSize: 20,
                                          color: AppColors.kTextDarkGreen),
                                ),
                                Text(
                                  targetUser.lable ?? "namratapuhar@gmail.com",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontSize: 15, color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            width: 0.22 * screenWidth,
                            height: 0.22 * screenWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(0.11 * screenWidth),
                              color: AppColors.kGreenYellow,
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            width: 0.64 * screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          fontSize: 20,
                                          color: AppColors.kTextDarkGreen),
                                ),
                                Text(
                                  "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontSize: 15, color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ),
          FutureBuilder(
            future: FirebaseHelper.getUserModelById(widget.userId),
            builder: (ctx, userData) {
              if (userData.connectionState == ConnectionState.done) {
                UserModel targetUser = userData.data as UserModel;

                return Column(
                  children: [
                    Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child:
                                  Image.asset('assets/images/reward_logo.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  targetUser.points.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.amber[600]),
                                ),
                                Text(
                                  " Points",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontSize: 22,
                                          color: AppColors.neutral90),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Global Rank",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.kTextDarkGreen),
                                  ),
                                  Text(
                                    targetUser.globalrank.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.neutral90,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 44,
                              color: AppColors.grey,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Drives",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.kTextDarkGreen),
                                  ),
                                  Text(
                                    targetUser.drives.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.neutral90,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 44,
                              color: AppColors.grey,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Plantation",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.kTextDarkGreen),
                                  ),
                                  Text(
                                    targetUser.lable.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.neutral90,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child:
                                  Image.asset('assets/images/reward_logo.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "0",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.amber[600]),
                                ),
                                Text(
                                  " Points",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          fontSize: 22,
                                          color: AppColors.neutral90),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Global Rank",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.kTextDarkGreen),
                                  ),
                                  Text(
                                    "0",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.neutral90,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 44,
                              color: AppColors.grey,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Drives",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.kTextDarkGreen),
                                  ),
                                  Text(
                                    "0",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.neutral90,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 44,
                              color: AppColors.grey,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Plantation",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.kTextDarkGreen),
                                  ),
                                  Text(
                                    "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            fontSize: 18,
                                            color: AppColors.neutral90,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          _riveArtboard != null
              ? SizedBox(
                  width: 320,
                  height: 400,
                  child: Rive(artboard: _riveArtboard!),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
