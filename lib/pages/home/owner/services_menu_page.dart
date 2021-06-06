import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/services_view.dart';
import 'package:provider/provider.dart';

import 'service_form_page.dart';

class SerivcesMenuPage extends StatefulWidget {
  const SerivcesMenuPage({Key? key}) : super(key: key);

  @override
  _SerivcesMenuPageState createState() => _SerivcesMenuPageState();
}

class _SerivcesMenuPageState extends State<SerivcesMenuPage> {
  bool _isEditable = false;

  void openServiceForm(Service? service, String? workshopUid) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ServiceFormPage(
            service: service,
            workshopUid:
                workshopUid == null ? service!.workshopUid : workshopUid),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);

    if (workshop == null) {
      return Text('No services');
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: ServicesView(
                workshop: workshop,
                isEditable: false,
                openServiceForm: openServiceForm)),
        floatingActionButton: FloatingActionButton(
          mini: _isEditable,
          onPressed: () {
            if (_isEditable) {
              openServiceForm(null, workshop.uid);
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
