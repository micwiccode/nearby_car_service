import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:nearby_car_service/utils/employees_service.dart';

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

  void handleEmployeeTap(
      {required BuildContext context,
      required Employee employee,
      required AppUser appUser}) {
    late ListTile tile;

    if (_isInvitedByOwner(employee)) {
      tile = ListTile(
        leading: Icon(Icons.send, size: 30.0),
        title: Text('Resend invitation'),
        onTap: () => employeesService.inviteEmployeeToWorkshop(
            email: appUser.email!, position: employee.position),
      );
    } else {
      tile = ListTile(
        leading: Icon(Icons.check_circle_outlined, size: 30.0),
        title: Text('Accept employee registration'),
        onTap: () => employeesService.acceptEmployeeRegistration(employee.uid),
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListView(children: [
            tile,
            ListTile(
                leading: Icon(Icons.cancel, size: 30.0),
                title: Text('Remove'),
                onTap: () => employeesService.removeEmployee(employee.uid))
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

  Color _getTileColor(Employee employee) {
    return _isInvitedByOwner(employee) ? Colors.black26 : Colors.black;
  }

  Widget _buildTile(Employee employee) {
    Color tileColor = _getTileColor(employee);

    return StreamBuilder<AppUser>(
        stream: DatabaseService(uid: employee.appUserUid).appUser,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          AppUser appUser = snapshot.data!;

          return ListTile(
              trailing: Icon(Icons.more_horiz, size: 20.0),
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
                handleEmployeeTap(
                    context: context, employee: employee, appUser: appUser);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.employees.length < 1
            ? Center(child: Text(widget.noDataText))
            : SingleChildScrollView(
                child: Column(
                  children: widget.employees.map((Employee employee) {
                    return _buildTile(employee);
                  }).toList(),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openEmployeeForm(null);
          },
          child: Icon(Icons.add),
        ));
  }
}
