import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/service.dart';

class ServiceTile extends StatelessWidget {
  final Service service;
  final bool isEditable;
  final bool isServiceActive;
  final Function? onTap;
  final Color tileColor;

  const ServiceTile(
      {required this.service,
      this.tileColor = Colors.black,
      this.isEditable = false,
      this.isServiceActive = true,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: isEditable ? Icon(Icons.more_horiz, size: 20.0) : null,
        leading: isServiceActive
            ? Icon(
                Icons.check_circle_outlined,
                color: Colors.amber[600],
              )
            : Icon(
                Icons.cancel,
                color: Colors.black26,
              ),
        title: Text(service.name,
            style: TextStyle(fontWeight: FontWeight.w700, color: tileColor)),
        subtitle: Text('Min price: ${formatPrice(service.minPrice)}',
            style: TextStyle(color: tileColor)),
        onTap: () {
          if (onTap != null) {
            onTap!(service);
          }
        });
  }
}
