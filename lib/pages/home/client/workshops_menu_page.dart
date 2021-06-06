import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/coords.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import '../workshops_map.dart';
import 'workshop_client_page.dart';
import 'workshops_list.dart';

class WorkshopsMenuPage extends StatefulWidget {
  const WorkshopsMenuPage({Key? key}) : super(key: key);

  @override
  _WorkshopsMenuPageState createState() => _WorkshopsMenuPageState();
}

class _WorkshopsMenuPageState extends State<WorkshopsMenuPage> {
  bool _isMapDisplayed = false;
  List<Workshop> _workshops = [];
  Map<String, Marker> _markers = {};

  final TextEditingController _filterController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterController.addListener(_handleSearchWorkshops);
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() => _isMapDisplayed = !_isMapDisplayed);
  }

  void openWorkshopClientPage(Workshop workshop) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            WorkshopClientPage(workshop: workshop),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> _handleSearchWorkshops() async {
    String input = _filterController.text;
    if (input.length > 2) {
      List<Workshop> results =
          await WorkshopDatabaseService.searchWorkshops(input);
      final Map<String, Marker> markers = {};

      for (final workshop in results) {
        Address address = workshop.address!;
        Coords coords = address.coords!;
        final marker = Marker(
            markerId: MarkerId(workshop.uid),
            position: LatLng(coords.latitude, coords.longitude),
            infoWindow: InfoWindow(
              title: workshop.name,
              snippet: address.getAddressDetails(),
            ),
            onTap: () {
              openWorkshopClientPage(workshop);
            });
        markers[workshop.uid] = marker;
      }

      setState(() {
        _workshops = results;
        _markers = markers;
      });
    } else {
      setState(() {
        _workshops = [];
      });
    }
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _filterController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: IconButton(
              color: Colors.black,
              icon: Icon(Icons.search),
              iconSize: 20.0,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            contentPadding: EdgeInsets.only(left: 25.0),
            hintText: 'Search workshop...',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isMapDisplayed
            ? Stack(children: <Widget>[
                WorkshopsMap(workshops: _workshops, markers: _markers),
                _buildSearchInput()
              ])
            : Container(
                child: Column(children: <Widget>[
                _buildSearchInput(),
                WorkshopsList(
                    workshops: _workshops,
                    openWorkshopClientPage: openWorkshopClientPage),
              ])),
        floatingActionButton: FloatingActionButton(
            onPressed: toggleView,
            child:
                _isMapDisplayed ? Icon(Icons.list) : Icon(Icons.map_outlined)));
  }
}
