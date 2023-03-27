import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_oneplanet/theme/colors.dart';
import '../apis/apis.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class NewPost extends StatefulWidget {
  final UserModel currentUser;
  const NewPost({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {


  void sendMessage() async {
    String msg = descriptionController.text.trim();
    descriptionController.clear();

    final nowTime = DateTime.now().millisecondsSinceEpoch.toString();

    if (msg != "") {
      // Send the message
      PostModel newMessage = PostModel(
        time: nowTime,
        byid: APIs.user.uid,
        purpose: dropdownvalue,
        description: msg,
      );

      ///Setting the message inside messages collection in chatroom

      await APIs.firestore
          .collection("posts")
          .doc(newMessage.time)
          .set(newMessage.toJson());

      /// Adding Points

      int currentPoint = int.parse(widget.currentUser.points!);
      int currentDrives = int.parse(widget.currentUser.drives!);

      await APIs.firestore
          .collection("users")
          .doc(APIs.user.uid)
          .update({
        'points': "${currentPoint+5}",
        'drives': "${currentDrives+1}",
      });

      showDialog(context: context, builder: (BuildContext context){
        return const AlertDialog(
          title: Text("Wohoo Post Sent!"),
          content: Text("5 Points Added!"),
        );
      });

      log("Message sent to db");
    } else {
      showDialog(context: context, builder: (BuildContext context){
        return const AlertDialog(
          title: Text("Oops!"),
          content: Text("Make Sure Post is valid"),
        );
      });
    }
  }

  TextEditingController descriptionController = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'Plantation';

  // List of items in our dropdown menu
  var items = [
    'Plantation',
    'Beach Clean',
    'Food',
    'Books',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add a New Post",
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: AppColors.kDarkGreen),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                     "Purpose :",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(
                        fontSize: 20,
                        color: AppColors.kTextDarkGreen),
                  ),
                  SizedBox(width: 12,),
                  DropdownButton(
                    underline: SizedBox(),

                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            chatInput(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      sendMessage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 1,
                      shape: const StadiumBorder(),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Text(
                        "Post",
                        style: GoogleFonts.poppins(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                    )),
                SizedBox(width: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chatInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 15.5),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write your stories \n and experiences here.',
                        hintStyle:
                        Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: AppColors.kTextDarkGreen,
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
