import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/pages/shared/cars_list.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/cars_database.dart';
import 'package:provider/provider.dart';

import 'car_form_page.dart';

class CarsMenuPage extends StatefulWidget {
  const CarsMenuPage({Key? key}) : super(key: key);

  @override
  _CarsMenuPageState createState() => _CarsMenuPageState();
}

class _CarsMenuPageState extends State<CarsMenuPage> {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    void handleOpenCarForm(Car? car) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarFormPage(car: car)),
      );
    }

    return StreamBuilder<List<Car>>(
      stream: CarDatabaseService(appUserUid: appUser!.uid).cars,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        if (snapshot.data == null) {
          Text('Cars snapshot error');
        }

        return Scaffold(
            body: snapshot.data!.length < 1
                ? Center(child: Text('No cars'))
                : CarsList(
                    cars: snapshot.data!,
                    isEditable: true,
                    onTap: handleOpenCarForm),
            floatingActionButton: FloatingActionButton(
              onPressed: () => handleOpenCarForm(null),
              child: Icon(Icons.add),
            ));
      },
    );
  }
}
