import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_car_service/helpers/determine_position.dart';
import 'package:nearby_car_service/models/workshop.dart';

class WorkshopsMap extends StatefulWidget {
  final List<Workshop> workshops;
  final Map<String, Marker> markers;
  
  const WorkshopsMap(
      {required this.workshops, required this.markers, Key? key})
      : super(key: key);

  @override
  _WorkshopsMapState createState() => _WorkshopsMapState();
}

class _WorkshopsMapState extends State<WorkshopsMap> {
  LatLng _center = const LatLng(54.189, 16.1729);
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    determinePosition().then((Position position) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
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
            zoom: 11.0,
          ),
        ));
  }
}
