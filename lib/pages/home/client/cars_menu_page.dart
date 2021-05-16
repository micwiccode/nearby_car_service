import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
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

        return Scaffold(
            body: snapshot.data!.length < 1
                ? Center(child: Text('No cars'))
                : ListView(
                    children: snapshot.data!.map((Car car) {
                      String? avatar = car.avatar;
                      return ListTile(
                        leading: isAvatarDefined(avatar)
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(avatar),
                              )
                            : Icon(Icons.directions_car, size: 40.0),
                        trailing: Icon(Icons.more_horiz, size: 20.0),
                        title: Text(car.mark + ' ' + car.model),
                        subtitle: Text(car.productionYear.toString()),
                        onTap: () => handleOpenCarForm(car),
                      );
                    }).toList(),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => handleOpenCarForm(null),
              child: const Icon(Icons.add),
            ));
      },
    );
  }
}
