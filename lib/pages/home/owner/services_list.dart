import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/helpers/formatPrice.dart';

class ServicesList extends StatefulWidget {
  final List<Service> services;
  final Function? openServiceForm;
  final bool isEditable;

  ServicesList(
      {required this.services,
      required this.isEditable,
      this.openServiceForm,
      Key? key})
      : super(key: key);

  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  Color _getTileColor(Service service) {
    return service.isActive ? Colors.black : Colors.black26;
  }

  bool _isServiceActive(Service service) {
    return service.isActive;
  }

  Widget _buildTile(Service service) {
    bool isServiceActive = _isServiceActive(service);
    Color tileColor = _getTileColor(service);

    return ListTile(
        trailing: widget.isEditable ? Icon(Icons.more_horiz, size: 20.0) : null,
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
          if (widget.openServiceForm != null && widget.isEditable) {
            widget.openServiceForm!(service);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.services.length < 1
        ? Center(child: Text('No services'))
        : Column(
            children: widget.services.map((Service service) {
              return _buildTile(service);
            }).toList(),
          );
  }
}
