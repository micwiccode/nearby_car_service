import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';
import 'employee_workshops_list.dart';

class EmployeeWorkshopsMenuPage extends StatefulWidget {
  const EmployeeWorkshopsMenuPage({Key? key}) : super(key: key);

  @override
  _EmployeeWorkshopsMenuPageState createState() =>
      _EmployeeWorkshopsMenuPageState();
}

class _EmployeeWorkshopsMenuPageState extends State<EmployeeWorkshopsMenuPage> {
  @override
  Widget build(BuildContext context) {
    final employeeWorkshopUid = Provider.of<String?>(context);
    final appUser = Provider.of<AppUser?>(context);

    return StreamBuilder<List<Employee>>(
      stream: EmployeesDatabaseService(appUserUid: appUser!.uid).userEmployees,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        return EmployeeWorkshopsList(
          employeeWorkshopUid: employeeWorkshopUid!,
          employeeWorkshopUids: snapshot.data == null
              ? []
              : snapshot.data!.map((e) => e.workshopUid).toList(),
        );
      },
    );
  }
}
