import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/services_service.dart';

class PickServiceForm extends StatefulWidget {
  final Function onSave;
  final String workshopUid;

  const PickServiceForm(
      {required this.workshopUid, required this.onSave, Key? key})
      : super(key: key);

  @override
  _PickServiceFormState createState() => _PickServiceFormState();
}

class _PickServiceFormState extends State<PickServiceForm> {
  List<Service> _selectedServices = [];

  final _snackBar =
      SnackBar(content: Text('You have tto select min 1 service'));

  void selectService(Service service) {
    if (isSelected(service)) {
      setState(
          () => _selectedServices.removeWhere((s) => s.uid == service.uid));
    } else {
      setState(() => _selectedServices.add(service));
    }
  }

  bool isSelected(Service service) {
    return _selectedServices.any((s) => s.uid == service.uid);
  }

  Widget _buildTile(Service service) {
    bool isServiceSelected = isSelected(service);
    Color tileColor = isServiceSelected ? Colors.black : Colors.black45;

    return ListTile(
        leading: isServiceSelected
            ? Icon(
                Icons.check_circle_outlined,
                color: Colors.amber[600],
              )
            : Icon(
                Icons.cancel,
                color: Colors.black45,
              ),
        title: Text(service.name,
            style: TextStyle(fontWeight: FontWeight.w700, color: tileColor)),
        subtitle: Text('Min price: ${formatPrice(service.minPrice)}',
            style: TextStyle(color: tileColor)),
        onTap: () => selectService(service));
  }

  @override
  Widget build(BuildContext context) {
    void handleSavePickedServices() {
      if (_selectedServices.length > 0) {
        widget.onSave(_selectedServices);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }

    return StreamBuilder<List<Service>>(
      stream: ServicesDatabaseService(workshopUid: widget.workshopUid)
          .workshopActiveServices,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        List<Service> services = snapshot.data == null ? [] : snapshot.data!;

        return Column(
          children: [
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Pick services',
                  style: TextStyle(fontSize: 14),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(2, 2, 2, 12),
                child: Text(
                  'Select min 1 service',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )),
            SingleChildScrollView(
                child: Column(children: [
              ...services.map((Service service) {
                return _buildTile(service);
              }).toList()
            ])),
            Padding(
                padding: EdgeInsets.all(10.0),
                child:
                    Button(text: 'Next', onPressed: handleSavePickedServices)),
          ],
        );
      },
    );
  }
}
