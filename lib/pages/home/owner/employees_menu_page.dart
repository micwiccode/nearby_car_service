import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/home/owner/employees_list.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';

class EmployeesMenuPage extends StatefulWidget {
  const EmployeesMenuPage({Key? key}) : super(key: key);

  @override
  _EmployeesMenuPageState createState() => _EmployeesMenuPageState();
}

class _EmployeesMenuPageState extends State<EmployeesMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);

    if (workshop == null) {
      return Text('No employees');
    }

    return StreamBuilder<List<Employee>>(
      stream: EmployeesDatabaseService(workshopUid: workshop.uid)
          .myWorkshopEmployees,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        return EmployeesList(
            employees: snapshot.data == null ? [] : snapshot.data!,
            workshopUid: workshop.uid);
      },
    );
  }
}
