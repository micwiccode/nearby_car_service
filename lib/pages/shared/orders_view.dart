import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/utils/orders_service.dart';

import 'loading_spinner.dart';
import 'order_details_page.dart';
import 'orders_list.dart';

class OrdersView extends StatelessWidget {
  final String? workshopUid;
  final String? appUserUid;
  final String? employeeUid;

  const OrdersView(
      {this.workshopUid, this.appUserUid, this.employeeUid, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void openOrderDetailsPage(Order order) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              OrderDetailsPage(orderUid: order.uid, employeeUid: employeeUid),
          fullscreenDialog: true,
        ),
      );
    }

    return StreamBuilder<List<Order>>(
      stream: workshopUid != null && appUserUid == null
          ? OrdersDatabaseService(workshopUid: workshopUid).workshopOrders
          : OrdersDatabaseService(appUserUid: appUserUid).userOrders,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        return OrdersList(
            orders: snapshot.data == null ? [] : snapshot.data!,
            openOrderDetailsPage: openOrderDetailsPage);
      },
    );
  }
}
