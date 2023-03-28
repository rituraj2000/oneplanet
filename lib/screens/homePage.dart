import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_oneplanet/theme/colors.dart';
import 'package:project_oneplanet/widgets/feedCard.dart';

import '../apis/apis.dart';
import '../models/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "OnePlanet",
          style: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(color: AppColors.kDarkGreen),
        ),
      ),
      body: StreamBuilder(
          stream: APIs.firestore
              .collection("events")
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              ///Data is loading
              case ConnectionState.waiting:
                return const SizedBox();
              case ConnectionState.none:
                return Center(
                  child: Text(
                    "Oops! Check you network connection",
                    style: GoogleFonts.poppins(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );

              ///If some or all data is loaded
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list =
                    data?.map((e) => PostModel.fromJson(e.data())).toList() ??
                        [];

                if (list.isNotEmpty) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          child: FeedCard(currentPost: list[index]),
                        );
                      });
                } else {
                  return Center(
                    child: Text(
                      "Add posts to your feed! 👋",
                      style: GoogleFonts.poppins(
                        color: AppColors.kTextDarkGreen,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}
