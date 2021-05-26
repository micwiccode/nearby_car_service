import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/helpers/formatPrice.dart';
import 'service_form_page.dart';

class ServicesList extends StatefulWidget {
  final List<Service> services;
  final String workshopUid;

  ServicesList({required this.services, required this.workshopUid, Key? key})
      : super(key: key);

  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  bool _isEditable = false;

  Color _getTileColor(Service service) {
    return service.isActive ? Colors.black : Colors.black26;
  }

  bool _isServiceActive(Service service) {
    return service.isActive;
  }

  void openServiceForm(Service? service) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            ServiceFormPage(service: service, workshopUid: widget.workshopUid),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildTile(Service service) {
    bool isServiceActive = _isServiceActive(service);
    Color tileColor = _getTileColor(service);

    return ListTile(
        trailing: _isEditable ? Icon(Icons.more_horiz, size: 20.0) : null,
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
          if (_isEditable) {
            openServiceForm(service);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.services.length < 1
            ? Center(child: Text('No services'))
            : SingleChildScrollView(
                child: Column(
                  children: widget.services.map((Service service) {
                    return _buildTile(service);
                  }).toList(),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          mini: _isEditable,
          onPressed: () {
            if (_isEditable) {
              openServiceForm(null);
            } else {
              setState(() {
                _isEditable = !_isEditable;
              });
            }
          },
          child: Icon(_isEditable ? Icons.add : Icons.edit),
        ));
  }
}
