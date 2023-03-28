import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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

  //Google Maps Marker
  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;

  void _setMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/climate_action.png")
        .then((icon) {
      customMarker = icon;
    });
  }

  BitmapDescriptor _customIcon(String type) {
    BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/climate_action.png")
        .then((icon) {
      customMarker = icon;
    });
    return customIcon;
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

      print(_currentPosition);
    }
  }

  @override
  void initState() {
    super.initState();
    _setMarker();
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
            print("${lat}, ${lon}");

            var marker = Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(lat, lon),
              icon: customMarker,
              infoWindow: InfoWindow(title: doc['title']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(
                      eventID: "85d93410-cc14-11ed-8919-6b67cf216ad3",
                    ),
                  ),
                );
              },
            );

            _set.add(marker);
          }

          return GoogleMap(
            markers: _set,
            initialCameraPosition: _currentPosition,
          );
        },
      ),
    );
  }
}
