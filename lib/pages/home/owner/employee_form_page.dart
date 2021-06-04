import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/capitalize.dart';
import 'package:nearby_car_service/helpers/is_email_valid.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/utils/employees_service.dart';

import 'package:nearby_car_service/consts/employee_positions.dart' as POSITIONS;

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;
  final String workshopUid;
  EmployeeFormPage(
      {required this.employee, required this.workshopUid, Key? key})
      : super(key: key);

  @override
  _EmployeeFormPageState createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  String _error = '';
  bool _isLoading = false;
  String _position = '';
  TextEditingController _emailController = TextEditingController(text: '');
  late EmployeesDatabaseService employeesDatabaseEmployee;
  final GlobalKey<FormState> _employeeFormFormFormKey = GlobalKey<FormState>();

  void setEmployeePosition(postion) {
    _position = postion;
  }

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _position = widget.employee!.position;
    }
  }

  bool isValidStep() {
    return _employeeFormFormFormKey.currentState!.validate();
  }

  Future<void> handleUpdateEmployee() async {
    if (isValidStep()) {
      setState(() => _isLoading = true);

      if (widget.employee != null) {
        String employeeUid = widget.employee!.uid;
        await employeesDatabaseEmployee.updateEmployeePosition(
            employeeUid: employeeUid, position: _position);
      } else {
        try {
          await employeesDatabaseEmployee.inviteEmployeeToWorkshop(
              email: _emailController.text.trim(), position: _position);

          Navigator.of(context).pop();
        } catch (err) {
          setState(() => _error = err.toString());
        }
      }

      setState(() => _isLoading = false);
    }
  }

  Widget formInner() {
    return Container(
      margin: new EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.employee == null)
                TextFormFieldWidget(
                  labelText: 'Employee account email',
                  controller: _emailController,
                  functionValidate: () {
                    if (!isEmailValid(_emailController.text.trim())) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
              _buildDropdown(
                  'Position',
                  _position,
                  POSITIONS.POSITIONS.map((s) => capitalize(s)).toList(),
                  setEmployeePosition),
              ErrorMessage(error: _error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: 'Add',
                      onPressed: handleUpdateEmployee,
                      isLoading: _isLoading)),
            ]),
      ),
    );
  }

  Widget _buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownSearch(
            label: label,
            items: items,
            validator: (v) => v == null ? "This field is required" : null,
            showClearButton: true,
            onChanged: onChanged));
  }

  @override
  Widget build(BuildContext context) {
    employeesDatabaseEmployee = EmployeesDatabaseService(
      workshopUid: widget.workshopUid,
    );

    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.employee == null ? 'Add new employee' : 'Edit employee'),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.amber,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          )),
      body: Center(
        child: Form(key: _employeeFormFormFormKey, child: formInner()),
      ),
    );
  }
}
