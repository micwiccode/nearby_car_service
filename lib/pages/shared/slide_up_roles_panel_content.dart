import 'package:flutter/material.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;
import 'package:nearby_car_service/helpers/capitalize.dart';

import 'button.dart';

class SlideUpRolesPanel extends StatefulWidget {
  final List<String> roles;
  final Function onSelect;
  const SlideUpRolesPanel(
      {required this.roles, required this.onSelect, Key? key})
      : super(key: key);

  @override
  _SlideUpRolesPanelState createState() => _SlideUpRolesPanelState();
}

class _SlideUpRolesPanelState extends State<SlideUpRolesPanel> {
  String _selectedRole = ROLES.CLIENT;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.roles.first;
  }

  Widget buildRadioButton(String text, String value, onChanged) {
    return RadioListTile<String>(
        title: Text(text),
        value: value,
        groupValue: widget.roles.first,
        onChanged: (val) => onChanged(val));
  }

  List<Widget> buildRadioButtons() {
    return widget.roles
        .map((role) => buildRadioButton(
            capitalize(role),
            role,
            (value) => setState(() {
                  _selectedRole = value;
                })))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Column(children: <Widget>[
        ...buildRadioButtons(),
        Button(
            text: 'Continue',
            onPressed: () {
              Navigator.pop(context);
              widget.onSelect(_selectedRole);
            })
      ]),
    );
  }
}
