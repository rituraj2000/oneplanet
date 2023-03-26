import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_oneplanet/theme/colors.dart';
import 'package:rive/rive.dart';

class AccountPage extends StatefulWidget {
  final User currentUser;
  const AccountPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int points = 43;

  Artboard? _riveArtboard;
  SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/riveanimation/tree_demo.riv').then((data) async{
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if(controller != null) {
        artboard.addController(controller);
        _progress = controller.findInput('input');
        setState(() {
          _riveArtboard = artboard;
          _progress?.value = points.toDouble();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              points++;
              _progress?.value = points.toDouble();
            });
          },
          child: Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 55, left: 15, right: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: 0.22 * screenWidth,
                    height: 0.22 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.11 * screenWidth),
                      color: AppColors.kGreenYellow,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.currentUser.photoURL ??
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
                          widget.currentUser.displayName ?? "Namrata",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(
                                  fontSize: 20,
                                  color: AppColors.kTextDarkGreen),
                        ),
                        Text(
                          widget.currentUser.email ?? "namratapuhar@gmail.com",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontSize: 15, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    child: Image.asset('assets/images/reward_logo.png'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        points.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.amber[600]),
                      ),
                      Text(
                        " Points",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 22, color: AppColors.neutral90),
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
                          "165",
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
                          "387",
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
                          "Cherry",
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
          _riveArtboard!= null ? SizedBox(
            width: 320,
            height: 400,
            child: Rive(artboard: _riveArtboard!),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
