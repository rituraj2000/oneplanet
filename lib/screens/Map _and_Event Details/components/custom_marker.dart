import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker extends StatefulWidget {
  CustomMarker();

  @override
  _CustomMarkerState createState() => _CustomMarkerState();
}

class _CustomMarkerState extends State<CustomMarker> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[400]!,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        Icon(
          Icons.location_on,
          color: Colors.red,
          size: 24,
        ),
      ],
    );
  }
}

// Future<BitmapDescriptor> _createCustomMarkerBitmap(BuildContext context) async {
//   final customMarkerWidget = CustomMarker();
//   final pixelRatio = MediaQuery.of(context).devicePixelRatio;

//   final uint8List = await toImage(customMarkerWidget).toByteData(
//     format: ImageByteFormat.png,
//   );

//   final buffer = uint8List!.buffer.asUint8List();

//   return BitmapDescriptor.fromBytes(buffer);
// }
