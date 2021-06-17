import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/car_tile.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/service_tile.dart';
import 'package:nearby_car_service/pages/shared/workshop_tile.dart';
import 'package:nearby_car_service/utils/user_service.dart';

class ConfirmOrderForm extends StatelessWidget {
  final String appUserUid;
  final Car car;
  final bool isLoading;
  final Order order;
  final Workshop workshop;
  final Function onSave;

  const ConfirmOrderForm(
      {required this.appUserUid,
      required this.car,
      required this.isLoading,
      required this.order,
      required this.workshop,
      required this.onSave});

  Widget _buildLabel(String text) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)));
  }

  Widget _buildText(String text) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10), child: Text(text));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser>(
        stream: AppUserDatabaseService(uid: appUserUid).appUser,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          AppUser? user = snapshot.data;

          if (user == null) {
            return Text('Unexpected error');
          }

          return Container(
              child: SingleChildScrollView(
                  child: Column(children: [
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Check your order details',
                  style: TextStyle(fontSize: 14),
                )),
            Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  'See yout order below',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Client'),
                  _buildText('${user.firstName} ${user.lastName}'),
                  _buildText('${user.email}, ${user.phoneNumber}'),
                  _buildLabel('Car'),
                  CarTile(car: car),
                  _buildLabel('Workshop'),
                  WorkshopTile(workshop: workshop),
                  _buildLabel('Services'),
                  ...order.services
                      .map((service) => ServiceTile(service: service)),
                  _buildLabel('Summary'),
                  _buildText('Total min price: ${formatPrice(order.price)}'),
                ]),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Button(
                    text: 'Confirm', onPressed: onSave, isLoading: isLoading))
          ])));
        });
  }
}
