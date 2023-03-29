import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/screens/Account/profilePage.dart';
import 'package:project_oneplanet/theme/colors.dart';
import '../helper/firebase_helper.dart';
import 'package:intl/intl.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class FeedCard extends StatefulWidget {
  final PostModel currentPost;
  const FeedCard({Key? key, required this.currentPost}) : super(key: key);

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              AppColors.kCardLightGreen,
              AppColors.kCardLightYellow,
            ],
            begin: const FractionalOffset(1.0, 1.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 11, bottom: 11.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9.6),
              child: CachedNetworkImage(
                height: 300,
                width: double.maxFinite,
                imageUrl: widget.currentPost.photo ??
                    "https://cdn.dribbble.com/users/306504/screenshots/11602103/media/fcf2ee9ff42aa4ec7ddad101a99831c9.gif",
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: FirebaseHelper.getUserModelById(
                        widget.currentPost.userID!),
                    builder: (context, userData) {
                      if (userData.connectionState == ConnectionState.done) {
                        UserModel targetUser = userData.data as UserModel;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(userId: targetUser.id!),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: AppColors.white,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: targetUser.photo ??
                                      "https://t3.ftcdn.net/jpg/01/18/01/98/360_F_118019822_6CKXP6rXmVhDOzbXZlLqEM2ya4HhYzSV.jpg",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                      width: 18.0,
                                      height: 18.0,
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                targetUser.name ?? "Guest",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      fontSize: 17.5,
                                      color: AppColors.kTextDarkGreen,
                                    ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                SizedBox(
                  width: 300,
                  child: Text(
                    widget.currentPost.title ?? "Title",
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 18,
                          color: AppColors.kDarkGreen,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 3.4,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.kCardTagGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.5, horizontal: 8),
                    child: Text(
                      widget.currentPost.type ?? "Purpose",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 15.5,
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.kDarkGreen,
                      size: 20,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.currentPost.location ?? "Location",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 14.5,
                            color: AppColors.kTextDarkGreen,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.kDarkGreen,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${DateFormat.yMMMEd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.currentPost.eventTime ?? "0")))}  ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.currentPost.eventTime ?? "0")))}",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 14.5,
                            color: AppColors.kTextDarkGreen,
                          ),
                      maxLines: null,
                    ),
                  ],
                ),
                // Text(widget.currentPost.description ?? "description"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
