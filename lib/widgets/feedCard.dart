import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_oneplanet/theme/colors.dart';
import '../helper/firebase_helper.dart';
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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 11),
        child: Column(
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
                errorWidget: (context, url, error) =>
                const Icon(Icons.error),
            ),
            ),
            FutureBuilder(
                future:
                FirebaseHelper.getUserModelById(widget.currentPost.userID!),
                builder: (context, userData) {
                  if (userData.connectionState == ConnectionState.done) {
                    UserModel targetUser = userData.data as UserModel;
                    return Text(targetUser.name ?? "Guest");
                  } else {
                    return const SizedBox();
                  }
                }),
            Text(widget.currentPost.title ?? "Title"),
            Text(widget.currentPost.type ?? "Purpose"),
            Text(widget.currentPost.location ?? "Location"),
            Text(widget.currentPost.eventTime ?? "Time"),
            Text(widget.currentPost.description ?? "description"),
          ],
        ),
      ),
    );
  }
}
