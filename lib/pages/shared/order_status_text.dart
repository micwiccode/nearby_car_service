import 'package:flutter/material.dart';

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;

class OrderStatusText extends StatelessWidget {
  final String status;
  const OrderStatusText(this.status);

  Color getColor() {
    switch (status) {
      case STATUSES.NEW:
        {
          return Colors.blue;
        }

      case STATUSES.ACCEPTED:
        {
          return Colors.red;
        }

      case STATUSES.IN_PROGRESS:
        {
          return Colors.yellow.shade800;
        }

      case STATUSES.DONE:
        {
          return Colors.green;
        }

      case STATUSES.PAID:
        {
          return Colors.black;
        }

      default:
        {
          return Colors.black;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(status, style: TextStyle(color: getColor()));
  }
}
