import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/utils/user_service.dart';
import 'package:provider/provider.dart';

class UserRolePicker extends StatefulWidget {
  final Function goNext;

  const UserRolePicker({required this.goNext, Key? key}) : super(key: key);

  @override
  _UserRolePickerState createState() => _UserRolePickerState();
}

class _UserRolePickerState extends State<UserRolePicker> {
  final GlobalKey<FormState> _roleSelectFormKey = GlobalKey<FormState>();
  String _pickedRole = ROLES.CLIENT;

  Future<void> handleSubmit(String uid) async {
    AppUserDatabaseService databaseService = AppUserDatabaseService(uid: uid);
    await databaseService.updateAppUserRole([_pickedRole]);
    widget.goNext();
  }

  Widget _buildRadioButton(String text, String value, onChanged) {
    return RadioListTile<String>(
        title: Text(text),
        value: value,
        groupValue: _pickedRole,
        onChanged: (val) => onChanged(val));
  }

  Widget _buildRoleSelect(AppUser user) {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            'Who you are?',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(2.0),
          child: Text(
            'Later you will be able to add new role to your account',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      _buildRadioButton('Client', ROLES.CLIENT,
          (value) => setState(() => _pickedRole = value)),
      _buildRadioButton('Employee', ROLES.EMPLOYEE,
          (value) => setState(() => _pickedRole = value)),
      _buildRadioButton(
          'Owner', ROLES.OWNER, (value) => setState(() => _pickedRole = value)),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Button(text: 'Next', onPressed: () => handleSubmit(user.uid))),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    return Form(key: _roleSelectFormKey, child: _buildRoleSelect(appUser!));
  }
}
