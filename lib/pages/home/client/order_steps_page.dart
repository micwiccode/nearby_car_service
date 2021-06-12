import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class OnboardingPage extends StatefulWidget {
  final AppUser? user;
  OnboardingPage({required this.user, Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late DatabaseService databaseService;
  int _step = 1;
  Order order = Order();


  Future<void> goNext() async {
    setState(() => _step = _step + 1);
  }

  Widget getOrderView() {
    switch (_step) {
      case 1:
        return PickServiceForm(goNext: goNext);
      case 2:
        return PickCarForm(goNext: goNext);
      case 3:
        return ConfirmOrder();
      default:
        return PickServiceForm(goNext: goNext);
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
          getOrderView(),
        ])));
  }
}
