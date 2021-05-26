import 'package:dropdown_search/dropdown_search.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_employee/models/employee.dart';
import 'package:nearby_car_employee/models/employee.dart';
import 'package:nearby_car_employee/models/workshop.dart';
import 'package:nearby_car_employee/pages/shared/button.dart';
import 'package:nearby_car_employee/pages/shared/_error_message.dart';
import 'package:nearby_car_employee/pages/shared/price_input.dart';
import 'package:nearby_car_employee/utils/employees_employee.dart';
import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _position = widget.employee!.position;
    }
  }

  late EmployeesDatabaseService employeesDatabaseEmployee;
  final GlobalKey<FormState> _employeeFormFormFormKey = GlobalKey<FormState>();

  void setEmployeePosition(postion) {
    _position = postion;
  }

  Widget formInner() {
    bool isValidStep() {
      return _employeeFormFormFormKey.currentState!.validate();
    }

    Future<void> handleUpdateEmployee() async {
      if (isValidStep()) {
        setState(() {
          _isLoading = true;
        });

        if (widget.employee != null) {
          String employeeUid = widget.employee!.uid;
          await employeesDatabaseEmployee.updateEmployeePosition(
              employeeUid: employeeUid, position: _position);
        } else {
          await employeesDatabaseEmployee.inviteEmployeeToWorkshop(
              email: _emailController.text, position: _position);
        }
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Container(
      margin: new EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildDropdown('Position', _position,
                  enumToList(EmployeePositions.values), setEmployeePosition),
              ErrorMessage(error: _error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: 'Save',
                      onPressed: handleUpdateEmployee,
                      isLoading: _isLoading)),
            ]),
      ),
    );
  }

  Widget buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownSearch(
            label: label,
            items: items,
            validator: (v) => v == null ? "This field is required" : null,
            hint: "Select a country",
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
