import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/services_view.dart';
import 'package:provider/provider.dart';
import '../owner/service_form_page.dart';

class SerivcesMenuPage extends StatefulWidget {
  const SerivcesMenuPage({Key? key}) : super(key: key);

  @override
  _SerivcesMenuPageState createState() => _SerivcesMenuPageState();
}

class _SerivcesMenuPageState extends State<SerivcesMenuPage> {
  bool _isEditable = false;

  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<Workshop?>(context);

    if (workshop == null) {
      return Text('No workshop provided');
    }

    void onServiceTileTap(Service? service) {
      if (_isEditable) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => ServiceFormPage(
                service: service,
                workshopUid:
                    service == null ? workshop.uid : service.workshopUid),
            fullscreenDialog: true,
          ),
        );
      }
    }

    return Scaffold(
        body: ServicesView(
            workshopUid: workshop.uid,
            isEditable: false,
            onServiceTileTap: onServiceTileTap),
        floatingActionButton: FloatingActionButton(
          mini: _isEditable,
          onPressed: () {
            if (_isEditable) {
              onServiceTileTap(null);
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
