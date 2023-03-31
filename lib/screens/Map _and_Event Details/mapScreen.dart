import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_oneplanet/screens/Map%20_and_Event%20Details/event_details/event_details_page.dart';
import 'package:project_oneplanet/screens/Map%20_and_Event%20Details/event_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //Current Camera Position
  late CameraPosition _currentPosition = CameraPosition(
    target: LatLng(30, 30),
  );

  BitmapDescriptor _customIcon_donation = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _customIcon_cleanliness = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _customIcon_sustainable_cities =
      BitmapDescriptor.defaultMarker;
  BitmapDescriptor _customIcon_life_onLand = BitmapDescriptor.defaultMarker;

  void setCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/food_donation_icon.png")
        .then((icon) {
      _customIcon_donation = icon;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/cleanliness_circular.png")
        .then((icon) {
      _customIcon_cleanliness = icon;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            "assets/images/sustainable-cities_circular.png")
        .then((icon) {
      _customIcon_sustainable_cities = icon;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/life-on-land_circular.png")
        .then((icon) {
      _customIcon_life_onLand = icon;
    });
  }

  void getCurrentLocation() async {
    //Check Permission
    LocationPermission _permission = await Geolocator.checkPermission();

    if (_permission == LocationPermission.denied) {
      print("Permission Denied!");
    } else {
      final _position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = CameraPosition(
          target: LatLng(_position.latitude, _position.longitude),
          zoom: 14.0,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setCustomIcon();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          Set<Marker> _set = {};

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          for (var doc in snapshot.data!.docs) {
            var lat = double.parse(doc['lat']);
            var lon = double.parse(doc['lon']);
            var type = doc['type'];
            var eventID = doc['eventID'];
            var title = doc['title'];

            if (type.toString().toLowerCase().contains('food')) {
              var marker = Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(lat, lon),
                icon: _customIcon_donation,
                infoWindow: InfoWindow(title: doc['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        eventID: eventID,
                      ),
                    ),
                  );
                },
              );

              _set.add(marker);
            } else if (type == 'donation') {
              var marker = Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(lat, lon),
                icon: _customIcon_donation,
                infoWindow: InfoWindow(title: doc['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        eventID: eventID,
                      ),
                    ),
                  );
                },
              );

              _set.add(marker);
            } else if (type == 'cleanliness') {
              var marker = Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(lat, lon),
                icon: _customIcon_cleanliness,
                infoWindow: InfoWindow(title: doc['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        eventID: eventID,
                      ),
                    ),
                  );
                },
              );

              _set.add(marker);
            } else if (type == 'sustainable-cities') {
              var marker = Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(lat, lon),
                icon: _customIcon_sustainable_cities,
                infoWindow: InfoWindow(title: doc['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        eventID: eventID,
                      ),
                    ),
                  );
                },
              );

              _set.add(marker);
            } else if (type == 'life-on-land') {
              var marker = Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(lat, lon),
                icon: _customIcon_life_onLand,
                infoWindow: InfoWindow(title: doc['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        eventID: eventID,
                      ),
                    ),
                  );
                },
              );

              _set.add(marker);
            }
          }

          return Stack(
            children: [
              GoogleMap(
                markers: _set,
                initialCameraPosition: _currentPosition,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(50, 0, 0, 13),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(4, 6),
                          blurRadius: 4,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "popular events".toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final _location =
                            snapshot.data!.docs[index]['location'];

                        return Popular_Events_Widget(
                          location: _location,
                          onTap: () {
                            setState(() {
                              final _lat = snapshot.data!.docs[index]['lat'];
                              final _lon = snapshot.data!.docs[index]['lon'];
                              _currentPosition = CameraPosition(
                                zoom: 14,
                                target: LatLng(
                                    double.parse(_lat), double.parse(_lon)),
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 50,
                left: 35,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(4, 6),
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for a location",
                      hintStyle: TextStyle(fontSize: 12),
                      icon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Popular_Events_Widget extends StatelessWidget {
  final String location;
  Function onTap;

  Popular_Events_Widget({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 0, 100),
        padding: EdgeInsets.fromLTRB(30, 20, 50, 20),
        height: 150,
        decoration: BoxDecoration(
          color: Color(0xFF56C02B),
          borderRadius: BorderRadius.all(
            Radius.circular(40),
          ),
          border: Border.all(width: 3, color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(4, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location != null ? location : "NULL",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "SDG Club NITR",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "50 participants",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
