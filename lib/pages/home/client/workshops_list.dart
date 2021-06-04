import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';

class WorkshopsList extends StatefulWidget {
  final List<Workshop> workshops;
  final String? employeeWorkshopUid;

  WorkshopsList({required this.workshops, this.employeeWorkshopUid, Key? key})
      : super(key: key);

  @override
  _WorkshopsListState createState() => _WorkshopsListState();
}

class _WorkshopsListState extends State<WorkshopsList> {
  Color _getTileColor(Workshop workshop) {
    return _isWorkshopActive(workshop) ? Colors.black : Colors.black26;
  }

  bool _isWorkshopActive(Workshop workshop) {
    return widget.employeeWorkshopUid == null ||
        workshop.uid == widget.employeeWorkshopUid;
  }

  // void openWorkshopForm(Workshop? service) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(
  //       builder: (BuildContext context) =>
  //           WorkshopFormPage(service: service, workshopUid: widget.workshopUid),
  //       fullscreenDialog: true,
  //     ),
  //   );
  // }

  Widget _buildTile(Workshop workshop) {
    bool isWorkshopActive = _isWorkshopActive(workshop);
    Color tileColor = _getTileColor(workshop);

    Address address = workshop.address!;

    return ListTile(
        trailing: widget.employeeWorkshopUid != null
            ? Icon(Icons.more_horiz, size: 20.0)
            : null,
        title: Text(workshop.name,
            style: TextStyle(fontWeight: FontWeight.w700, color: tileColor)),
        subtitle: Text(address.getAddressDetails(),
            style: TextStyle(color: tileColor)),
        leading:
            (workshop.avatar != null && workshop.avatar!.contains('/storage'))
                ? CachedNetworkImage(
                    imageUrl: workshop.avatar!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => LoadingSpinner(),
                  )
                : Icon(
                    Icons.business_center_outlined,
                    color: Colors.black,
                    size: 25.0,
                  ),
        onTap: () {
          // if (_isEditable) {
          //   openWorkshopForm(service);
          // }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.workshops.length < 1
            ? Center(child: Text('You have no workshops'))
            : SingleChildScrollView(
                child: Column(
                  children: widget.workshops.map((Workshop workshop) {
                    return _buildTile(workshop);
                  }).toList(),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // if (_isEditable) {
            //   openWorkshopForm(null);
            // } else {
            //   setState(() {
            //     _isEditable = !_isEditable;
            //   });
            // }
          },
          child: Icon(Icons.add),
        ));
  }
}
