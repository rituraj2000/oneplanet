import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/apis/apis.dart';
import 'package:project_oneplanet/theme/colors.dart';

class AccountPage extends StatefulWidget {
  final User currentUser;
  const AccountPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: 0.22 * screenWidth,
                    height: 0.22 * screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.11 * screenWidth),
                      color: Colors.white,
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
                    width: 0.64*screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currentUser.displayName ?? "Namrata",
                          style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontSize: 20, color: AppColors.kTextDarkGreen),
                        ),
                        Text(
                          widget.currentUser.email ?? "namratapuhar@gmail.com",
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontSize: 15, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text("Global Rank", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18, color: AppColors.kTextDarkGreen),),
                        Text("165", style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18, color: AppColors.neutral90, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 44,
                    color: AppColors.kGreenYellow,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text("Drives", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18, color: AppColors.kTextDarkGreen),),
                        Text("387", style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18, color: AppColors.neutral90, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 44,
                    color: AppColors.kGreenYellow,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text("Plantation", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 18, color: AppColors.kTextDarkGreen),),
                        Text("Cherry", style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 18, color: AppColors.neutral90, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
