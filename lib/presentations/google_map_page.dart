import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage({Key key}) : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    GoogleMapsServices googleMapsServices = GoogleMapsServices();
    googleMapsServices
        .getRouteCoordinates(
            LatLng(23.0500, 72.6700), LatLng(23.0350, 72.52930))
        .then((value) => print(value ?? 'dfff'));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Polyline Google Map'),
      ),
      // body: GoogleMap(
      //   // mapType: MapType.hybrid,

      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
    );
  }
}

class GoogleMapsServices {
  String apiKey = "AIzaSyC-i6EsYRC1WVvuKUl1WH_F-Ua2hVXQVHw";
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    print(url);
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}
