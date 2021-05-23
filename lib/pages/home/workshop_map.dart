import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_car_service/models/coords.dart';

class WorkshopMap extends StatefulWidget {
  final Coords coords;
  const WorkshopMap({required this.coords, Key? key}) : super(key: key);

  @override
  _WorkshopsMapState createState() => _WorkshopsMapState();
}

class _WorkshopsMapState extends State<WorkshopMap> {
  late LatLng _center;
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.coords.latitude, widget.coords.longitude);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    await _configureMarker();
  }

  Future<void> _configureMarker() async {
    setState(() {
      _markers.clear();
      String markerId = '${_center.latitude} ${_center.longitude}';
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: _center,
      );
      _markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      markers: _markers.values.toSet(),
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
    );
  }
}
