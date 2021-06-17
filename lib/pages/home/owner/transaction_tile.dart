

import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/app_transaction.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/orders_service.dart';

class TransactionTile extends StatelessWidget {
  final AppTransaction transaction;

  const TransactionTile({required this.transaction});

    String getTitle(List<Service> services) => 
     services[0].name + (services.length > 1 ? ' + ${services.length - 1}' : '');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Order>(
      stream: OrdersDatabaseService(orderUid: transaction.orderUid).order,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        if (snapshot.data == null) {
          return Text('Order snapshot error');
        }

       Order order = snapshot.data!;
        
        return ListTile(
        leading:  Icon(
                Icons.check_circle_outlined,
                color: Colors.amber[600],
              ),
        title: Text(getTitle(order.services),
            style: TextStyle(fontWeight: FontWeight.w700, color:  Colors.black)),
        subtitle: Text('${formatPrice(transaction.price)}',
            style: TextStyle(color: Colors.black)),
       );});
  }
}
