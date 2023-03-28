import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_oneplanet/helper/firestore_methods.dart';
import 'package:project_oneplanet/theme/colors.dart';
import 'package:intl/intl.dart';
import '../../apis/apis.dart';
import '../../helper/dialogs.dart';
import '../../models/user_model.dart';

class NewPost extends StatefulWidget {
  final UserModel currentUser;
  const NewPost({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String? image;
  String imageURL = "";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime date = DateTime.now();

  LatLng _location_cordinates = LatLng(30, 30);

  var items = [
    'Plantation',
    'Beach Clean',
    'Food',
    'Books',
    'Item 5',
  ];
  String dropdownvalue = 'Plantation';

  //Functions : Scheduling a New Event
  Future<void> getLocation(String locationName) async {
    try {
      List<Location> locations = await locationFromAddress(locationName);
      Location location = locations.first;
      _location_cordinates = LatLng(location.latitude, location.longitude);
      print(
          'Latitude: ${_location_cordinates.latitude}, Longitude: ${_location_cordinates.longitude}');
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void _scheduleEvent() async {
      String msg = _titleController.text.trim();

      final nowTime = DateTime.now().millisecondsSinceEpoch.toString();

      if (msg != "" &&
          _locationController.text.trim() != "" &&
          _descriptionController.text.trim() != "") {
        // Send the message

        try {
          await getLocation(_locationController.text);
          await FirestoreMethods()
              .uploadScheduledEvent(
            _titleController.text,
            nowTime,
            _descriptionController.text.trim(),
            nowTime,
            _locationController.text.trim(),
            _location_cordinates.latitude.toString(),
            _location_cordinates.longitude.toString(),
            dropdownvalue,
            date.millisecondsSinceEpoch.toString(),
            imageURL,
          ).then((value) async{
            /// Adding Points

            int currentPoint = int.parse(widget.currentUser.points!);
            int currentDrives = int.parse(widget.currentUser.drives!);

            await APIs.firestore.collection("users").doc(APIs.user!.uid).update({
              'points': "${currentPoint + 5}",
              'drives': "${currentDrives + 1}",
            }).then((value) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text("Wohoo Post Sent!"),
                      content: Text("5 Points Added!"),
                    );
                  }).then((value) {
                /// Clean it at end
                _titleController.clear();
                _descriptionController.clear();
                _locationController.clear();
                Future.delayed(const Duration(milliseconds: 200), () {
                  Navigator.pop(context);
                });
              });
            });
          });
        } catch (e) {
          print(e.toString());
        }


        log("Message sent to db");
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Oops!"),
                content: Text("Make Sure Post is valid"),
              );
            });
      }
    }

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Purpose Dropdown
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
                                  fontSize: 16,
                                  color: AppColors.kTextDarkGreen),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        DropdownButton(
                          underline: SizedBox(),
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
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

                  SizedBox(height: 6,),
                  //Calendar Button
                  Padding(
                    padding: const EdgeInsets.only(top: 1, left: 8),
                    child: Row(
                      children: [
                        // Text(
                        //   "Time :",
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .subtitle1!
                        //       .copyWith(
                        //       fontSize: 16,
                        //       color: AppColors.kTextDarkGreen,
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        Text(
                          "${DateFormat.yMMMEd().format(date)}  ${DateFormat.jm().format(date)}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                            fontSize: 16.5,
                              color: AppColors.kTextDarkGreen,
                          ),
                          maxLines: null,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            DateTime newDate = DateTime.now();

                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1960),
                                maxTime: DateTime(2050), onChanged: (date) {
                                  newDate = date;
                                }, onConfirm: (date) {
                                  newDate = date;
                                  setState(() {
                                    this.date = newDate;
                                  });
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: Icon(Icons.calendar_month_sharp, size: 15),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 1,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              //Photo Input
              image == null ? GestureDetector(
                onTap: () {
                  showBottomSheet(screenHeight);
                },
                child: Container(
                  height: 300,
                  width: screenWidth,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ) : Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    File(image!),
                    width: screenWidth,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              chatInput(
                  hint: 'Title',
                  minLines: 1,
                  textEditingController: _titleController),
              chatInput(
                  hint: 'Location',
                  minLines: 1,
                  textEditingController: _locationController),
              chatInput(
                  hint: 'Desciption',
                  minLines: 9,
                  textEditingController: _descriptionController),
              //Post button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _scheduleEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 1,
                      shape: const StadiumBorder(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: Text(
                        "Post",
                        style: GoogleFonts.poppins(
                            fontSize: 19, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }


  //Update Profile Picture
   Future<void> updateProfilePicture(File file) async {
    //image file extension
    final ext = file.path.split('.').last;
    //storage file reference path
    final ref = APIs.storage.ref().child('profile_pictures/${date.millisecondsSinceEpoch.toString()}.$ext');

    //Uploading Image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //Updating new image in firestore db
    await ref.getDownloadURL().then((value) {
      setState(() {
        imageURL = value;
      });
    });
  }

  //bottom sheet for picking a profile picture
  void showBottomSheet(double height) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: height * 0.03, bottom: height * 0.09),
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kTextDarkGreen),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kLightGreen,
                      shape: const CircleBorder(),
                      fixedSize: Size(height * 0.11, height * 0.11),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        log('Image Path: ${image.path} --Mime Type: ${image.mimeType}');
                        setState(() {
                          this.image = image.path;
                        });
                        //Update profile pic
                        updateProfilePicture(File(this.image!));
                        Dialogs.showSnackbar(
                            context, "Profile Picture Updated!");
                        //Hiding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.photo,
                          size: height * 0.0514,
                        ),
                        Text(
                          "Gallery",
                          style: GoogleFonts.poppins(
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kLightGreen,
                      shape: const CircleBorder(),
                      fixedSize: Size(height * 0.11, height * 0.11),
                    ),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image from camera
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log('Image Path: ${image.path} --Mime Type: ${image.mimeType}');
                        setState(() {
                          this.image = image.path;
                        });
                        //Update pic
                        updateProfilePicture(File(this.image!));
                        Dialogs.showSnackbar(
                            context, "Profile Picture Updated!");
                        //Hiding bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.camera,
                          size: height * 0.0514,
                        ),
                        Text(
                          "Camera",
                          style: GoogleFonts.poppins(
                            fontSize: height * 0.015,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }


  Widget chatInput(
      {required String hint,
      required int minLines,
      required TextEditingController textEditingController}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 11,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.multiline,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontSize: 15.5),
                      minLines: minLines,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        alignLabelWithHint: true,
                        hintText: hint,
                        hintStyle:
                            Theme.of(context).textTheme.subtitle2!.copyWith(
                                  color: AppColors.kTextDarkGreen,
                                  fontSize: 14.5,
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
