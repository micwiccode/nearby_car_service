import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/coords.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/home/workshop_map.dart';
import 'package:url_launcher/url_launcher.dart';

import 'confirm_dialog.dart';

class WorkshopView extends StatelessWidget {
  final Workshop workshop;
  final Function? openManageModal;

  const WorkshopView({this.openManageModal, required this.workshop, Key? key})
      : super(key: key);

  Future<void> _sendSMS(String phoneNumber) async {
    String url = 'sms:$phoneNumber';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  Future<void> _dailNumber(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  Future<void> _sendEmail(String email) async {
    String url = 'mailto:$email?subject=Nearby car service client question';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    String? workshopAvatar = workshop.avatar;
    Address workshopAddress = workshop.address!;

    bool isClientView = openManageModal == null;

    Future<void> _openGoogleMaps(Coords? coords) async {
      if (coords == null) {
        final _snackBar =
            SnackBar(content: Text('This workshop has no coords provided'));

        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }

      String url =
          'https://www.google.com/maps/search/?api=1&query=${coords!.latitude},${coords.longitude}';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        final _snackBar = SnackBar(content: Text('Could not open a map'));

        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }

    Future<void> _usePhoneNumber(String phoneNumber) async {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => ConfirmDialog(
              acceptLabel: 'Make a call',
              denyLabel: 'Send SMS',
              onAccept: () {
                Navigator.pop(context);
                _dailNumber(phoneNumber);
              },
              onDeny: () {
                Navigator.pop(context);
                _sendSMS(phoneNumber);
              },
              title: 'What do you want to do?'));
    }

    return Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: isAvatarDefined(workshopAvatar)
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(workshopAvatar!),
                    )
                  : Icon(Icons.business_outlined, size: 100.0)),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Text(
                      workshop.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    )),
                if (!isClientView)
                  GestureDetector(
                      child: Icon(Icons.more_horiz),
                      onTap: () => openManageModal!())
              ]),
          GestureDetector(
              onTap: () {
                if (isClientView) {
                  _sendEmail(workshop.email);
                }
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(width: 2, color: Colors.black12)),
                    child: Icon(
                      Icons.email,
                      size: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    workshop.email,
                    style: TextStyle(fontSize: 15.0),
                  ),
                ],
              )),
          GestureDetector(
              onTap: () {
                if (isClientView) {
                  _usePhoneNumber(workshop.phoneNumber);
                }
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(width: 2, color: Colors.black12)),
                    child: Icon(
                      Icons.local_phone,
                      size: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    workshop.phoneNumber,
                    style: TextStyle(fontSize: 15.0),
                  ),
                ],
              )),
          GestureDetector(
              onTap: () {
                if (isClientView) {
                  _openGoogleMaps(workshopAddress.coords);
                }
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(width: 2, color: Colors.black12)),
                    child: Icon(
                      Icons.location_on,
                      size: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${workshopAddress.street} ${workshopAddress.streetNumber}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(
                          "${workshopAddress.zipCode} ${workshopAddress.city}",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ]),
                ],
              )),
          Container(
              height: 200,
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: workshopAddress.coords != null
                  ? WorkshopMap(coords: workshopAddress.coords!)
                  : null)
        ]));
  }
}
