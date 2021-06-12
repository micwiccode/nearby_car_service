import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/orders_view.dart';
import 'package:provider/provider.dart';

class OrdersMenuPage extends StatefulWidget {
  const OrdersMenuPage({Key? key}) : super(key: key);

  @override
  _OrdersMenuPageState createState() => _OrdersMenuPageState();
}

class _OrdersMenuPageState extends State<OrdersMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);

    if (workshop == null) {
      return Text('No orders');
    }

    return OrdersView(workshopUid: workshop.uid);
  }
}
