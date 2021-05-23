import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:provider/provider.dart';

import 'package:nearby_car_service/pages/home/workshop_map.dart';
import 'package:nearby_car_service/pages/shared/slide_up_manage_panel_content.dart';
import 'package:nearby_car_service/pages/shared/confirm_dialog.dart';
import 'workshop_form_page.dart';

class WorkshopMenuPage extends StatefulWidget {
  const WorkshopMenuPage({Key? key}) : super(key: key);

  @override
  _WorkshopMenuPageState createState() => _WorkshopMenuPageState();
}

class _WorkshopMenuPageState extends State<WorkshopMenuPage> {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    final WorkshopDatabaseService workshopDatabaseService =
        WorkshopDatabaseService(
      appUserUid: appUser!.uid,
    );

    return StreamBuilder<Workshop>(
      stream: WorkshopDatabaseService(appUserUid: appUser!.uid).myWorkshop,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        if (snapshot.data == null) {
          return Text('No workshop');
        }

        Workshop workshop = snapshot.data!;
        String? workshopAvatar = workshop.avatar;
        Address workshopAddress = workshop.address!;

        return Scaffold(
            body: SingleChildScrollView(
                child: _buildWorkshopView(
                    context: context,
                    workshopDatabaseService: workshopDatabaseService,
                    workshop: workshop,
                    workshopAddress: workshopAddress,
                    workshopAvatar: workshopAvatar)));
      },
    );
  }
}

Widget _buildWorkshopView(
    {context,
    workshopDatabaseService,
    workshop,
    workshopAddress,
    workshopAvatar}) {
  void onEditWorkshop() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkshopFormPage(
                workshop: workshop,
              )),
    );
  }

  void onRemoveWorkshop() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
            onAccept: () {
              Navigator.pop(context);
              workshopDatabaseService.removeWorkshop(workshop.uid);
            },
            onDeny: () {
              Navigator.pop(context);
            },
            title: 'Do you really want to remove workshop?'));
  }

  return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  GestureDetector(
                      child: Icon(Icons.more_horiz),
                      onTap: () => openManageModal(
                          context: context,
                          workshop: workshop,
                          handleEdit: onEditWorkshop,
                          handleRemove: onRemoveWorkshop))
                ]),
            Row(
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
            ),
            Row(
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
            ),
            Row(
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ),
            Container(
                height: 200,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: workshopAddress.coords != null
                    ? WorkshopMap(coords: workshopAddress.coords!)
                    : null)
          ]));
}

openManageModal(
    {required BuildContext context,
    required Workshop workshop,
    required handleEdit,
    required handleRemove}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SlideUpManagePanel(
          editText: 'Edit workshop',
          removeText: 'Remove workshop',
          handleEdit: () {
            Navigator.pop(context);
            handleEdit();
          },
          handleRemove: () {
            Navigator.pop(context);
            handleRemove();
          });
    },
  );
}
