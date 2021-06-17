import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/car.dart';

import 'car_tile.dart';

class CarsList extends StatelessWidget {
  final List<Car> cars;
  final Function onTap;
  final bool isEditable;

  const CarsList(
      {required this.cars,
      required this.onTap,
      this.isEditable = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: cars.map((Car car) {
        return CarTile(car: car, onTap: onTap, isEditable: isEditable);
      }).toList(),
    );
  }
}
