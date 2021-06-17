import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:provider/provider.dart';

import 'new_employee_page.dart';

class EmployeeWorkshopsList extends StatefulWidget {
  final List<String> employeeWorkshopUids;
  final String employeeWorkshopUid;

  EmployeeWorkshopsList(
      {required this.employeeWorkshopUids,
      required this.employeeWorkshopUid,
      Key? key})
      : super(key: key);

  @override
  _EmployeeWorkshopsListState createState() => _EmployeeWorkshopsListState();
}

class _EmployeeWorkshopsListState extends State<EmployeeWorkshopsList> {
  EmployeesDatabaseService employeesService = EmployeesDatabaseService();

  Color _getTileColor(Workshop workshop) {
    return _isWorkshopActive(workshop) ? Colors.black : Colors.black26;
  }

  bool _isWorkshopActive(Workshop workshop) {
    return workshop.uid == widget.employeeWorkshopUid;
  }

  void openEmployeeForm() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => NewEmployeePage(),
        fullscreenDialog: true,
      ),
    );
  }

  void openSwitchWorkshopSlideUp(Workshop workshop, String userUid) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ListTile(
                leading: Icon(Icons.business_center_outlined, size: 30.0),
                title: Text('Switch to this workshop'),
                onTap: () async {
                  await setSteamPreferencesEmployeeWorkshopUid(
                      workshop.uid, userUid);
                  Navigator.of(context).pop();
                }),
            if (workshop.appUserUid == userUid)
              ListTile(
                  leading: Icon(Icons.cancel, size: 30.0),
                  title: Text('Remove'),
                  onTap: () async {
                    Employee? employee = await employeesService
                        .getEmployeeByUserAndWorkshop(workshop.uid, userUid);

                    if (employee != null) {
                      employeesService.removeEmployee(employee);
                    }
                  })
          ]),
        );
      },
    );
  }

  Widget _buildTile(String workshopUid, String userUid) {
    return StreamBuilder<Workshop>(
        stream:
            WorkshopDatabaseService(workshopUid: workshopUid).employeeWorkshop,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          if (snapshot.data == null) {
            return ListTile();
          }

          Workshop workshop = snapshot.data!;

          Color tileColor = _getTileColor(workshop);
          bool isActive = _isWorkshopActive(workshop);
          Address address = workshop.address!;

          return ListTile(
              trailing: !isActive || workshop.appUserUid == userUid
                  ? Icon(Icons.more_horiz, size: 20.0)
                  : null,
              title: Text(workshop.name,
                  style:
                      TextStyle(fontWeight: FontWeight.w700, color: tileColor)),
              subtitle: Text(address.getAddressDetails(),
                  style: TextStyle(color: tileColor)),
              leading: (workshop.avatar != null &&
                      workshop.avatar!.contains('/storage'))
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
                if (!isActive || workshop.appUserUid == userUid) {
                  openSwitchWorkshopSlideUp(workshop, userUid);
                }
              });
        });
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    List<String> inactiveWorkshopUids = widget.employeeWorkshopUids
        .where(
            (String workshopUid) => workshopUid != widget.employeeWorkshopUid)
        .toList();
    String activeWorkshopUid = widget.employeeWorkshopUids.firstWhere(
        (String workshopUid) => workshopUid == widget.employeeWorkshopUid,
        orElse: () => '');

    return Scaffold(
        body: widget.employeeWorkshopUids.length < 1
            ? Center(child: Text('You have no workshops'))
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    _buildLabel('Active workshop'),
                    if (activeWorkshopUid == '')
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 10, 16.0, 16.0),
                        child: Text('No active workshop'),
                      )
                    else
                      _buildTile(activeWorkshopUid, appUser!.uid),
                    if (inactiveWorkshopUids.length > 0)
                      _buildLabel('Other workshops'),
                    ...inactiveWorkshopUids.map((String workshopUid) {
                      return _buildTile(workshopUid, appUser!.uid);
                    }).toList()
                  ])),
        floatingActionButton: FloatingActionButton(
          onPressed: openEmployeeForm,
          child: Icon(Icons.add),
        ));
  }
}
