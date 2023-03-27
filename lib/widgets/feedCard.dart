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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            FutureBuilder(
                future: FirebaseHelper.getUserModelById(widget.currentPost.byid!),
                builder: (context, userData) {
                  if (userData.connectionState == ConnectionState.done) {
                    UserModel targetUser = userData.data as UserModel;
                    return Text(targetUser.name!);
                  } else {
                    return const SizedBox();
                  }
                }),
            Text(widget.currentPost.purpose ?? "Purpose"),
            Text(widget.currentPost.description ?? "description"),
          ],
        ),
      ),
    );
  }
}
