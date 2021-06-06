import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';

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
  Widget _buildTile(Workshop workshop) {
    Address address = workshop.address!;

    return ListTile(
        title: Text(workshop.name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            )),
        subtitle: Text(address.getAddressDetails()),
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
          widget.openWorkshopClientPage(workshop);
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.workshops.length < 1
        ? Center(child: Text('No workshops'))
        : ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: widget.workshops.map((Workshop workshop) {
              return _buildTile(workshop);
            }).toList(),
          );
  }
}
