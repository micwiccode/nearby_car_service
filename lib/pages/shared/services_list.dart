import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/pages/shared/service_tile.dart';

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

    return ServiceTile(
        service: service,
        isEditable: widget.isEditable,
        tileColor: tileColor,
        onTap: widget.openServiceForm,
        isServiceActive: isServiceActive);
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
