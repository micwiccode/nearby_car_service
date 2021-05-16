import 'package:flutter/material.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

import 'button.dart';

class SlideUpRolesPanel extends StatefulWidget {
  final List<String> roles;
  const SlideUpRolesPanel({required this.roles, Key? key})
      : super(key: key);

  @override
  _SlideUpRolesPanelState createState() => _SlideUpRolesPanelState();
}

class _SlideUpRolesPanelState extends State<SlideUpRolesPanel> {
  List<String> roles = [ROLES.CLIENT, ROLES.EMPLOYEE, ROLES.OWNER];
  String _selectedRole = ROLES.CLIENT;

  @override
  void initState() {
    super.initState();
    _selectedRole =
        roles.where((role) => !widget.roles.contains(role)).first;
  }

  Widget buildRadioButton(String text, String value, onChanged) {
    return RadioListTile<String>(
        title: Text(text),
        value: value,
        groupValue: widget.roles.first,
        onChanged: (val) => onChanged(val));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      buildRadioButton(
          'Client',
          ROLES.CLIENT,
          (value) => setState(() {
                _selectedRole = value;
              })),
      buildRadioButton(
          'Employee',
          ROLES.EMPLOYEE,
          (value) => setState(() {
                _selectedRole = value;
              })),
      buildRadioButton(
          'Owner',
          ROLES.OWNER,
          (value) => setState(() {
                _selectedRole = value;
              })),
      Button(text: 'Continue', onPressed: ()=>{})
    ]);
  }
}
