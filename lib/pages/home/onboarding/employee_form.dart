import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/commonForms/new_employee_from.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({Key? key}) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  @override
  Widget build(BuildContext context) {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Find your workshop and specify your position',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      NewEmployeeForm()
    ])));
  }
}
