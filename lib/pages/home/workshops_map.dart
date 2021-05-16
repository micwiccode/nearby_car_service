import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorkshopsMap extends StatefulWidget {
  const WorkshopsMap({Key? key}) : super(key: key);

  @override
  _WorkshopsMapState createState() => _WorkshopsMapState();
}

class _WorkshopsMapState extends State<WorkshopsMap> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }
}
