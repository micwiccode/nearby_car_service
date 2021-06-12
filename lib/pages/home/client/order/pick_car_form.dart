import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/pages/shared/cars_list.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/cars_database.dart';

import '../car_form_page.dart';

class PickCarForm extends StatelessWidget {
  final String appUserUid;
  final Function onSave;

  const PickCarForm({required this.appUserUid, required this.onSave});

  @override
  Widget build(BuildContext context) {
    void handleOpenCarForm(Car? car) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarFormPage(car: car)),
      );
    }

    return StreamBuilder<List<Car>>(
      stream: CarDatabaseService(appUserUid: appUserUid).cars,
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

        List<Car> cars = snapshot.data!;

        return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  child: Column(children: [
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Pick a car',
                      style: TextStyle(fontSize: 14),
                    )),
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Select which car is an object of an order',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )),
                SingleChildScrollView(
                    child: Column(children: [
                  snapshot.data!.length < 1
                      ? Center(child: Text('You have no cars, press + to add'))
                      : Center(child: CarsList(cars: cars, onTap: onSave))
                ]))
              ])),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: () => handleOpenCarForm(null),
                      child: Icon(Icons.add),
                    ),
                  ))
            ]);
      },
    );
  }
}
