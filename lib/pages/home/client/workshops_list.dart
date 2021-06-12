import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/workshop_tile.dart';

class WorkshopsList extends StatefulWidget {
  final List<Workshop> workshops;
  final Function openWorkshopClientPage;

  WorkshopsList(
      {required this.workshops, required this.openWorkshopClientPage, Key? key})
      : super(key: key);

  @override
  _WorkshopsListState createState() => _WorkshopsListState();
}

class _WorkshopsListState extends State<WorkshopsList> {
  @override
  Widget build(BuildContext context) {
    return widget.workshops.length < 1
        ? Center(child: Text('No workshops'))
        : ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: widget.workshops.map((Workshop workshop) {
              return WorkshopTile(
                  workshop: workshop, onTap: widget.openWorkshopClientPage);
            }).toList(),
          );
  }
}
