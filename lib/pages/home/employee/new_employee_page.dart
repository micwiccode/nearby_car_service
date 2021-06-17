import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/commonForms/new_employee_form.dart';

class NewEmployeePage extends StatelessWidget {
  const NewEmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add workshop'),
          backgroundColor: Colors.amber,
        ),
        body: Center(child: NewEmployeeForm()));
  }
}
