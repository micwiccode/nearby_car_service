import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/orders_view.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';

class OrdersMenuPage extends StatefulWidget {
  const OrdersMenuPage({Key? key}) : super(key: key);

  @override
  _OrdersMenuPageState createState() => _OrdersMenuPageState();
}

class _OrdersMenuPageState extends State<OrdersMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshopUid = Provider.of<String?>(context);
    final appUser = Provider.of<AppUser?>(context);

    if (workshopUid == null || appUser == null) {
      return Text('No workshop or user error');
    }

    return StreamBuilder<Employee>(
        stream: EmployeesDatabaseService(
                workshopUid: workshopUid, appUserUid: appUser.uid)
            .employee,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          if (snapshot.data == null) {
            return Text('Employee snapshot error');
          }

          Employee employee = snapshot.data!;

          return Scaffold(
              body: OrdersView(
                  workshopUid: workshopUid, employeeUid: employee.uid));
        });
  }
}
