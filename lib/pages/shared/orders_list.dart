import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/order.dart';

import 'order_tile.dart';

class OrdersList extends StatelessWidget {
  final List<Order> orders;
  final Function openOrderDetailsPage;

  const OrdersList({required this.orders, required this.openOrderDetailsPage});

  @override
  Widget build(BuildContext context) {
    return orders.length < 1
        ? Center(child: Text('No orders'))
        : ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: orders.map((Order order) {
              return OrderTile(
                  order: order, onTap: openOrderDetailsPage, isEditable: true);
            }).toList(),
          );
  }
}
