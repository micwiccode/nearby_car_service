import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/home/onboarding/owner_form.dart';
import 'package:nearby_car_service/utils/user_service.dart';
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
  late AppUserDatabaseService databaseService;
  int _step = 1;

  Future<void> skipOnboarding() async {
    print('here');
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
    databaseService = AppUserDatabaseService(uid: appUser!.uid);

    if (widget.user != null && widget.user!.onboardingStep != null) {
      initateOnbordingStep();
    }

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
