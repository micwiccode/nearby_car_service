import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/employee.dart';

import 'employee_form_page.dart';

class EmployeesList extends StatefulWidget {
  final List<Employee> employees;
  final String workshopUid;

  EmployeesList({required this.employees, required this.workshopUid, Key? key})
      : super(key: key);

  @override
  _EmployeesListState createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
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

  Widget _buildTile(Employee employee) {
    return ListTile(
        trailing: Icon(Icons.more_horiz, size: 20.0),
        leading: Icon(
          Icons.person,
          color: Colors.black87,
        ),
        title: Text(
            '${employee.appUser!.firstName} ${employee.appUser!.lastName}',
            style: TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(employee.position),
        onTap: () {
          openEmployeeForm(employee);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.employees.length < 1
            ? Center(child: Text('No employees'))
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
