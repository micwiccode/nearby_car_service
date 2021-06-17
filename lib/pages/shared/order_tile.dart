import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/utils/cars_database.dart';
import 'package:nearby_car_service/utils/user_service.dart';

import 'loading_spinner.dart';
import 'order_status_text.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final Function onTap;
  final bool isEditable;
  final bool isEmployeeView;

  const OrderTile(
      {required this.order,
      required this.onTap,
      required this.isEditable,
      this.isEmployeeView = false});

  String getTitle(List<Service> services, AppUser user) => isEmployeeView
      ? '${user.firstName} ${user.lastName}'
      : services[0].name +
          (services.length > 1 ? ' + ${services.length - 1}' : '');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser>(
        stream: AppUserDatabaseService(uid: order.appUserUid).appUser,
        initialData: null,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          if (snapshot.data == null) {
            return Text('No user in order error');
          }

          AppUser appUser = snapshot.data!;

          return StreamBuilder<Car>(
              stream: CarDatabaseService(carUid: order.carUid).car,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingSpinner();
                }

                if (snapshot.data == null) {
                  return Text('No car in order error');
                }

                Car car = snapshot.data!;

                return ListTile(
                    trailing: OrderStatusText(order.status),
                    leading: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.amber[600],
                    ),
                    title: Text(getTitle(order.services, appUser),
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(formatPrice(order.price)),
                    onTap: () => onTap(order, car));
              });
        });
  }
}
