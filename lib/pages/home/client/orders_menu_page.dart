import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/shared/orders_view.dart';
import 'package:provider/provider.dart';

class OrdersMenuPage extends StatelessWidget {
  const OrdersMenuPage();

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return Scaffold(body: OrdersView(appUserUid: appUser!.uid));
  }
}
