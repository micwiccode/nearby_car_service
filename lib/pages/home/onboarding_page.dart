import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

enum UserRole { owner, employee, client }

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  UserRole? _role = UserRole.client;
  Object user = {};
  int step = 1;
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';

  Widget getStepView() {
    switch (step) {
      case 1:
        return _buildRoleSelect();
      case 2:
        return _buildUserDetailsForm();
      case 3:
        return _buildRoleBasedForm();
      default:
        return _buildRoleSelect();
    }
  }

  void goNext() {
    print('go next');
    setState(() => step++);
  }

  void goBack() {
    setState(() => step = step < 2 ? 1 : step--);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
        child: Column(children: <Widget>[
          CircularStepProgressIndicator(
            totalSteps: 3,
            currentStep: step,
            stepSize: 5,
            selectedColor: Colors.amber[700],
            unselectedColor: Colors.grey[200],
            padding: 0,
            width: 60,
            height: 60,
            selectedStepSize: 8,
            roundedCap: (_, __) => true,
          ),
          getStepView(),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Button(text: 'Next', onPressed: goNext)),
          if (step > 1)
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Button(text: 'Back', onPressed: goBack))
        ]));
  }

  Widget _buildRoleSelect() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Who you are?',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to add new role to your account',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      _buildRadioButton('Client', UserRole.client),
      _buildRadioButton('Employee', UserRole.employee),
      _buildRadioButton('Owner', UserRole.owner),
    ])));
  }

  Widget _buildUserDetailsForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Tell something more about yourself',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      _buildTextField('First name', firstName),
      _buildTextField('Last name', lastName),
      _buildTextField('Phone number', phoneNumber),
    ])));
  }

  Widget _buildRoleBasedForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Provide some additional info',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      _buildTextField('First name', firstName),
      _buildTextField('Last name', lastName),
      _buildTextField('Phone number', phoneNumber),
    ])));
  }

  Widget _buildTextField(String text, String value) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormFieldWidget(
        labelText: text,
        onChanged: (val) {
          setState(() => value = val);
        },
        functionValidate: (String? name) {
          if (name == null || name.trim().isEmpty) {
            return 'Please enter $text';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRadioButton(String text, UserRole value) {
    return RadioListTile<UserRole>(
      title: Text(text),
      value: value,
      groupValue: _role,
      onChanged: (UserRole? value) {
        setState(() => _role = value);
      },
    );
  }
}
