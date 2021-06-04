import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_car_service/helpers/determine_position.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/coords.dart';
import 'package:nearby_car_service/models/workshop.dart';

class WorkshopsMap extends StatefulWidget {
  final List<Workshop> workshops;
  const WorkshopsMap({required this.workshops, Key? key}) : super(key: key);

  @override
  _WorkshopsMapState createState() => _WorkshopsMapState();
}

class _WorkshopsMapState extends State<WorkshopsMap> {
  late LatLng _center;
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

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
    await _configureMarker();
  }

  Future<void> _configureMarker() async {
    setState(() {
      _markers.clear();
      for (final workshop in widget.workshops) {
        Address address = workshop.address!;
        Coords coords = address.coords!;
        final marker = Marker(
          markerId: MarkerId(workshop.uid),
          position: LatLng(coords.latitude, coords.longitude),
          infoWindow: InfoWindow(
            title: workshop.name,
            snippet: address.getAddressDetails(),
          ),
        );
        _markers[workshop.uid] = marker;
      }
    });
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
