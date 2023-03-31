// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:project_oneplanet/screens/Map%20_and_Event%20Details/event_details_screen.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   //Current Camera Position
//   late CameraPosition _currentPosition = CameraPosition(
//     target: LatLng(30, 30),
//   );

//   //Custom Google Maps Markers
//   BitmapDescriptor _customIcon_Food_Donation = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor _customIconPlantation = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor _customIcon_Climate_Action = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor _customIcon_Life_on_Land = BitmapDescriptor.defaultMarker;

//   void setCustomIcon() {
//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/food_donation_icon.png")
//         .then((icon) {
//       _customIcon_Food_Donation = icon;
//     });

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/live_on_land.png")
//         .then((icon) {
//       _customIconPlantation = icon;
//     });

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/climate_action.png")
//         .then((icon) {
//       _customIcon_Climate_Action = icon;
//     });

//     BitmapDescriptor.fromAssetImage(
//             ImageConfiguration.empty, "assets/images/live_on_land.png")
//         .then((icon) {
//       _customIcon_Life_on_Land = icon;
//     });
//   }

//   void getCurrentLocation() async {
//     //Check Permission
//     LocationPermission _permission = await Geolocator.checkPermission();

//     if (_permission == LocationPermission.denied) {
//       print("Permission Denied!");
//     } else {
//       final _position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _currentPosition = CameraPosition(
//           target: LatLng(_position.latitude, _position.longitude),
//           zoom: 14.0,
//         );
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setCustomIcon();
//     getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('events').snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           Set<Marker> _set = {};

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           for (var doc in snapshot.data!.docs) {
//             var lat = double.parse(doc['lat']);
//             var lon = double.parse(doc['lon']);
//             var type = doc['type'];
//             var eventID = doc['eventID'];
//             var title = doc['title'];

//             //print("${lat}, ${lon}, ${title}");

//             if (type.toString().toLowerCase().contains('food')) {
//               var marker = Marker(
//                 markerId: MarkerId(doc.id),
//                 position: LatLng(lat, lon),
//                 icon: _customIcon_Food_Donation,
//                 infoWindow: InfoWindow(title: doc['title']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EventDetailsScreen(
//                         eventID: eventID,
//                       ),
//                     ),
//                   );
//                 },
//               );

//               _set.add(marker);
//             } else if (type == 'cleanliness') {
//               var marker = Marker(
//                 markerId: MarkerId(doc.id),
//                 position: LatLng(lat, lon),
//                 icon: _customIcon_Climate_Action,
//                 infoWindow: InfoWindow(title: doc['title']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EventDetailsScreen(
//                         eventID: eventID,
//                       ),
//                     ),
//                   );
//                 },
//               );

//               _set.add(marker);
//             } else if (type == 'life_on_land' || type == 'life-on-land') {
//               var marker = Marker(
//                 markerId: MarkerId(doc.id),
//                 position: LatLng(lat, lon),
//                 icon: _customIcon_Life_on_Land,
//                 infoWindow: InfoWindow(title: doc['title']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EventDetailsScreen(
//                         eventID: eventID,
//                       ),
//                     ),
//                   );
//                 },
//               );

//               _set.add(marker);
//             }
//           }

//           return GoogleMap(
//             markers: _set,
//             initialCameraPosition: _currentPosition,
//           );
//         },
//       ),
//     );
//   }
// }
