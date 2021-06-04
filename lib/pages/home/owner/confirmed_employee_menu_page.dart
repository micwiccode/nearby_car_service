import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/home/owner/employees_list.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';

class ConfirmedEmployeesMenuPage extends StatefulWidget {
  const ConfirmedEmployeesMenuPage({Key? key}) : super(key: key);

  @override
  _ConfirmedEmployeesMenuPageState createState() =>
      _ConfirmedEmployeesMenuPageState();
}

class _ConfirmedEmployeesMenuPageState
    extends State<ConfirmedEmployeesMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);
    final String noDataText = 'No active employees';

    if (workshop == null) {
      return Text(noDataText);
    }

    return StreamBuilder<List<Employee>>(
      stream: EmployeesDatabaseService(workshopUid: workshop.uid)
          .workshopConfirmedEmployees,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        return EmployeesList(
            noDataText: noDataText,
            employees: snapshot.data == null ? [] : snapshot.data!,
            workshopUid: workshop.uid);
      },
    );
  }
}
