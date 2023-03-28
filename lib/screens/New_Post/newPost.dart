import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_oneplanet/helper/firestore_methods.dart';
import 'package:project_oneplanet/theme/colors.dart';
import '../../apis/apis.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class NewPost extends StatefulWidget {
  final UserModel currentUser;
  const NewPost({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

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

  void _showCalendar() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _scheduleEvent() async {
      try {
        await getLocation(_locationController.text);
        String res = await FirestoreMethods().uploadScheduledEvent(
          _titleController.text,
          DateTime.now().microsecondsSinceEpoch.toString(),
          _descriptionController.text.trim(),
          DateTime.now().millisecondsSinceEpoch.toString(),
          _locationController.text.trim(),
          _location_cordinates.latitude.toString(),
          _location_cordinates.longitude.toString(),
          "climate_action",
        );

        Navigator.pop(context);
      } catch (e) {
        print(e.toString());
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
          child: Column(
            children: [
              Row(
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
                                  fontSize: 15,
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

                  //Calendar Button
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.calendar_month_sharp, size: 15),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 1,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  )
                ],
              ),

              //Photo Input
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              chatInput(
                  hint: 'Title',
                  minLines: 1,
                  textEditingController: _titleController),
              chatInput(
                  hint: 'location',
                  minLines: 1,
                  textEditingController: _locationController),
              chatInput(
                  hint: 'desciption',
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
            ],
          ),
        ),
      ),
    );
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
                                  fontSize: 13,
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
