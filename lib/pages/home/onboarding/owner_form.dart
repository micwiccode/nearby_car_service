import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/commonForms/workshop_form.dart';

class OwnerForm extends StatefulWidget {
  const OwnerForm({Key? key}) : super(key: key);

  @override
  _OwnerFormState createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  Widget _buildOwnerForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Add your workshop',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      WorkshopForm()
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return _buildOwnerForm();
  }
}
