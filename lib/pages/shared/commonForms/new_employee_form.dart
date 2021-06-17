import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/capitalize.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/pages/shared/workshops_search_input.dart';
import 'package:nearby_car_service/utils/user_service.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';

import 'package:nearby_car_service/consts/employee_positions.dart' as POSITIONS;
import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class NewEmployeeForm extends StatefulWidget {
  const NewEmployeeForm({Key? key}) : super(key: key);

  @override
  _NewEmployeeFormState createState() => _NewEmployeeFormState();
}

class _NewEmployeeFormState extends State<NewEmployeeForm> {
  late AppUserDatabaseService databaseService;
  final GlobalKey<FormState> _employeeFormKey = GlobalKey<FormState>();
  String _error = '';
  bool _isLoading = false;
  Workshop? _selectedWorkshop;
  String _selectedPosition = POSITIONS.MECHANIC;

  bool isValid() {
    return _employeeFormKey.currentState!.validate();
  }

  Future<void> sendRegistrationToWorkshop(String appUserUid) async {
    if (_selectedWorkshop == null) {
      return;
    }

    if (isValid()) {
      setState(() => _isLoading = true);

      String selectedWorkshopUid = _selectedWorkshop!.uid;

      EmployeesDatabaseService employeesDatabaseService =
          EmployeesDatabaseService(workshopUid: selectedWorkshopUid);

      try {
        await employeesDatabaseService.sendRegistrationToWorkshop(
            workshopUid: selectedWorkshopUid,
            position: _selectedPosition,
            appUserUid: appUserUid);

        await databaseService.addAppUserRole(ROLES.EMPLOYEE);
        await databaseService.updateAppUserOnboardingStep(4);

        await setPreferencesUserRole(ROLES.EMPLOYEE, appUserUid);
      } catch (err) {
        setState(() => _error = err.toString());
      }
      setState(() => _isLoading = false);
    }
  }

  void setEmployeeWorkshop(workshop) {
    _selectedWorkshop = workshop;
  }

  void setEmployeePosition(postion) {
    _selectedPosition = postion;
  }

  Widget _buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: DropdownSearch(
            label: label,
            items: items,
            validator: (v) => v == null ? "This field is required" : null,
            showClearButton: true,
            onChanged: onChanged));
  }

  Widget _buildNewEmployeeForm(String appUserUid) {
    return Container(
        child: Column(children: <Widget>[
      WorkshopsSearchInput(
          label: 'Workshop',
          selectedItem: _selectedWorkshop,
          onChanged: setEmployeeWorkshop),
      _buildDropdown(
          'Position',
          _selectedPosition,
          POSITIONS.POSITIONS.map((s) => capitalize(s)).toList(),
          setEmployeePosition),
      ErrorMessage(error: _error),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Button(
              text: 'Next',
              onPressed: () => sendRegistrationToWorkshop(appUserUid),
              isLoading: _isLoading)),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    databaseService = AppUserDatabaseService(
      uid: appUser!.uid,
    );

    return Form(
        key: _employeeFormKey, child: _buildNewEmployeeForm(appUser.uid));
  }
}
