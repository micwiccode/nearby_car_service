import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/confirm_dialog.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/user_service.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';

import 'employee_form_page.dart';

class EmployeesList extends StatefulWidget {
  final List<Employee> employees;
  final String workshopUid;
  final String noDataText;

  EmployeesList(
      {required this.employees,
      required this.workshopUid,
      required this.noDataText,
      Key? key})
      : super(key: key);

  @override
  _EmployeesListState createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  late EmployeesDatabaseService employeesService;

  @override
  void initState() {
    super.initState();
    employeesService =
        EmployeesDatabaseService(workshopUid: widget.workshopUid);
  }

  void onRemoveEmployee(Employee employee) {
    print('here');
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
            onAccept: () async {
              print('remomve');
              await employeesService.removeEmployee(employee);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            onDeny: () {
              Navigator.pop(context);
            },
            title: 'Do you really want to remove employee?'));
  }

  void handleEmployeeTap(
      {required BuildContext context,
      required Employee employee,
      required AppUser appUser,
      required String currentAppUserUid}) {
    late ListTile? tile;

    if (_isInvitedByOwner(employee)) {
      tile = ListTile(
        leading: Icon(Icons.send, size: 30.0),
        title: Text('Resend invitation'),
        onTap: () async {
          await employeesService.inviteEmployeeToWorkshop(
              email: appUser.email!,
              position: employee.position,
              currentAppUserUid: currentAppUserUid,
              context: context,
              enableResend: true);
          Navigator.of(context).pop();
        },
      );
    } else if (_isNotConfirmed(employee)) {
      tile = ListTile(
        leading: Icon(Icons.check_circle_outlined, size: 30.0),
        title: Text('Accept employee registration'),
        onTap: () async {
          employeesService.acceptEmployeeRegistration(employee.uid);
          Navigator.of(context).pop();
        },
      );
    } else {
      tile = null;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            tile != null ? tile : Container(),
            ListTile(
                leading: Icon(Icons.cancel, size: 30.0),
                title: Text('Remove'),
                onTap: () {
                  Navigator.of(context).pop();
                  onRemoveEmployee(employee);
                })
          ]),
        );
      },
    );
  }

  void openEmployeeForm(Employee? employee) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => EmployeeFormPage(
            employee: employee, workshopUid: widget.workshopUid),
        fullscreenDialog: true,
      ),
    );
  }

  bool _isInvitedByOwner(Employee employee) {
    return employee.isConfirmedByOwner && !employee.isConfirmedByEmployee;
  }

  bool _isNotConfirmed(Employee employee) {
    return !employee.isConfirmedByOwner;
  }

  Color _getTileColor(Employee employee) {
    return _isInvitedByOwner(employee) ? Colors.black26 : Colors.black;
  }

  Widget _buildTile(Employee employee) {
    Color tileColor = _getTileColor(employee);

    return StreamBuilder<AppUser>(
        stream: AppUserDatabaseService(uid: employee.appUserUid).appUser,
        builder: (BuildContext context, snapshot) {
          final loggedAppUser = Provider.of<AppUser?>(context);

          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          AppUser appUser = snapshot.data!;

          bool isUserItself = loggedAppUser!.uid == appUser.uid;

          return ListTile(
              trailing:
                  !isUserItself ? Icon(Icons.more_horiz, size: 20.0) : null,
              leading: (appUser.avatar != null &&
                      appUser.avatar!.contains('/storage'))
                  ? CachedNetworkImage(
                      imageUrl: appUser.avatar!,
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
                      Icons.person,
                      color: Colors.black87,
                    ),
              title: Text('${appUser.firstName} ${appUser.lastName}',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, color: tileColor)),
              subtitle:
                  Text(employee.position, style: TextStyle(color: tileColor)),
              onTap: () {
                if (!isUserItself) {
                  handleEmployeeTap(
                      context: context,
                      employee: employee,
                      appUser: appUser,
                      currentAppUserUid: appUser.uid);
                }
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.employees.length < 1
            ? Center(child: Text(widget.noDataText))
            : ListView(
                children: widget.employees.map((Employee employee) {
                  return _buildTile(employee);
                }).toList(),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openEmployeeForm(null);
          },
          child: Icon(Icons.add),
        ));
  }
}
