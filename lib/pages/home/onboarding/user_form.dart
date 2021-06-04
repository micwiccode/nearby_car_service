import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/commonForms/profile_form.dart';

class UserDetailsForm extends StatelessWidget {
  final Function goNext;

  UserDetailsForm({required this.goNext});

  Widget _buildUserDetailsForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Tell something more about yourself',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      ProfileForm(goNext: goNext),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return _buildUserDetailsForm();
  }
}
