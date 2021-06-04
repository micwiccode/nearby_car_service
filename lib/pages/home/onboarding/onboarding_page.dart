import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/home/onboarding/owner_form.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

import 'client_form.dart';
import 'employee_form.dart';
import 'user_form.dart';
import 'user_role_picker.dart';

class OnboardingPage extends StatefulWidget {
  final AppUser? user;
  OnboardingPage({required this.user, Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late DatabaseService databaseService;
  int _step = 1;
  // late AppUser _user;
  // Workshop _workshop = Workshop(
  //   name: '',
  //   email: '',
  //   phoneNumber: '',
  //   address: new Address(street: '', streetNumber: '', city: '', zipCode: ''),
  // );
  // Employee _employee = Employee();
  // Car _car = Car();

  // List<Workshop> testWorkshops = <Workshop>[
  //   Workshop(
  //       name: '123',
  //       email: 'email',
  //       phoneNumber: 'phoneNumber',
  //       address: Address(
  //           street: 'street',
  //           streetNumber: 'streetNum',
  //           zipCode: '11-111',
  //           city: 'City')),
  //   Workshop(
  //       name: '234',
  //       email: 'email',
  //       phoneNumber: 'phoneNumber',
  //       address: Address(
  //           street: 'street',
  //           streetNumber: 'streetNum',
  //           zipCode: '11-111',
  //           city: 'City')),
  // ];

  Future<void> skipOnboarding() async {
    await databaseService.updateAppUserOnboardingStep(4);
  }

  Future<void> goNext() async {
    setState(() => _step = _step + 1);
  }

  Widget getStepView() {
    switch (_step) {
      case 1:
        return UserDetailsForm(goNext: goNext);
      case 2:
        return UserRolePicker(goNext: goNext);
      case 3:
        if (widget.user!.roles!.contains(ROLES.CLIENT))
          return ClientForm(skipOnboarding: skipOnboarding);
        else if (widget.user!.roles!.contains(ROLES.EMPLOYEE))
          return EmployeeForm();
        else
          return OwnerForm();
      default:
        return UserDetailsForm(goNext: goNext);
    }
  }

  @override
  Widget build(BuildContext context) {
    void initateOnbordingStep() {
      setState(() => _step = widget.user!.onboardingStep!);
    }

    AppUser? appUser = Provider.of<AppUser?>(context);
    databaseService = DatabaseService(uid: appUser!.uid);

    if (widget.user != null && widget.user!.onboardingStep != null) {
      // setState(() => _user = widget.user!);
      initateOnbordingStep();
    }
    // else {
    //   setState(() => _user =
    //       AppUser(uid: appUser.uid, roles: [ROLES.CLIENT], onboardingStep: 2));
    // }

    // Future<void> saveStepState() async {
    //   if (_step == 1) {
    //     await databaseService.updateAppUser(_user);
    //   } else if (_step == 2) {
    //     await databaseService.updateAppUserRole(_user.roles ?? [ROLES.CLIENT]);
    //   } else {
    //     switch (_user.roles![0]) {
    //       case ROLES.CLIENT:
    //         print(_car);
    //         break;
    //       case ROLES.EMPLOYEE:
    //         print(_employee);
    //         break;
    //       case ROLES.OWNER:
    //         print(_workshop);
    //         break;
    //     }
    //   }
    // }

    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          CircularStepProgressIndicator(
            totalSteps: 4,
            currentStep: _step,
            stepSize: 5,
            selectedColor: Colors.amber[700],
            unselectedColor: Colors.grey[200],
            padding: 0,
            width: 55,
            height: 55,
            selectedStepSize: 8,
            roundedCap: (_, __) => true,
          ),
          getStepView(),
        ])));
  }
}
