import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_car_service/helpers/determine_position.dart';
import 'package:nearby_car_service/models/workshop.dart';

class WorkshopsMap extends StatefulWidget {
  final List<Workshop> workshops;
  final Map<String, Marker> markers;

  const WorkshopsMap({required this.workshops, required this.markers, Key? key})
      : super(key: key);

  @override
  _WorkshopsMapState createState() => _WorkshopsMapState();
}

class _WorkshopsMapState extends State<WorkshopsMap> {
  LatLng _center = LatLng(54.189, 16.1729);
  double _zoom = 13.0;

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    determinePosition().then((Position position) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    });

    int markersLength = widget.markers.length;

    if (markersLength == 0) {
      setState(() {
        _zoom = 0;
      });
      return;
    }

    if (markersLength == 1) {
      setState(() {
        _center = widget.markers.values.toList()[0].position;
      });
      return;
    }

    double latitudesAvg = widget.markers.values
            .map((marker) => marker.position.latitude)
            .reduce((a, b) => a + b) /
        markersLength;
    double longitudesAvg = widget.markers.values
            .map((marker) => marker.position.longitude)
            .reduce((a, b) => a + b) /
        markersLength;

    double latitudeMax = widget.markers.values
        .map((marker) => marker.position.latitude)
        .reduce(max);
    double latitudeMin = widget.markers.values
        .map((marker) => marker.position.latitude)
        .reduce(min);

    double longitudeMax = widget.markers.values
        .map((marker) => marker.position.longitude)
        .reduce(max);
    double longitudeMin = widget.markers.values
        .map((marker) => marker.position.longitude)
        .reduce(min);

    LatLng center = LatLng(latitudesAvg, longitudesAvg);

    double zoom =
        max((longitudeMax - longitudeMin), (latitudeMax - latitudeMin));

    print(zoom);

    setState(() {
      _center = center;
      _zoom = zoom > 5 ? zoom / 5 : zoom * 4;
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        transform: Matrix4.translationValues(0.0, -5.0, 0.0),
        child: GoogleMap(
          markers: widget.markers.values.toSet(),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: _zoom,
          ),
        ));
  }
}
