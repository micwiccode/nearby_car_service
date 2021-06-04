import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/home/owner/services_list.dart';
import 'package:nearby_car_service/utils/services_service.dart';
import 'package:provider/provider.dart';

class TransactionsMenuPage extends StatefulWidget {
  const TransactionsMenuPage({Key? key}) : super(key: key);

  @override
  _TransactionsMenuPageState createState() => _TransactionsMenuPageState();
}

class _TransactionsMenuPageState extends State<TransactionsMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);

    if (workshop == null) {
      return Text('No services');
    }

    return StreamBuilder<List<Service>>(
      stream:
          ServicesDatabaseService(workshopUid: workshop.uid).myWorkshopServices,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        return ServicesList(
            services: snapshot.data == null ? [] : snapshot.data!,
            workshopUid: workshop.uid);
      },
    );
  }
}
