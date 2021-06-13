import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:nearby_car_service/utils/orders_service.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'confirm_order_form.dart';
import 'pick_car_form.dart';
import 'pick_service_form.dart';

class OrderStepsPage extends StatefulWidget {
  final Workshop workshop;

  OrderStepsPage({required this.workshop, Key? key}) : super(key: key);

  @override
  _OrderStepsPageState createState() => _OrderStepsPageState();
}

class _OrderStepsPageState extends State<OrderStepsPage> {
  late DatabaseService databaseService;
  int _step = 1;
  Order _order = Order();
  Car _car = Car();
  bool _isLoading = false;

  Future<void> goNext() async {
    setState(() => _step = _step + 1);
  }

  void handleSavePickedServices(List<Service> services) {
    int minPriceSum =
        services.fold(0, (sum, service) => sum + service.minPrice);

    print(services);
    print(minPriceSum);

    setState(() => {_order.services = services, _order.price = minPriceSum});
    goNext();
  }

  void handleSavePickedCar(Car car) {
    setState(() => {_order.carUid = car.uid, _car = car});
    goNext();
  }

  void handleSaveOrder(
      BuildContext context, String appUserUid, String workshopUid) async {
    setState(() => _isLoading = true);

    _order.appUserUid = appUserUid;
    _order.workshopUid = workshopUid;

    await OrdersDatabaseService().createOrder(_order);

    setState(() => _isLoading = false);

    Navigator.of(context).pop();
  }

  Widget getOrderView(
      BuildContext context, String appUserUid, String workshopUid) {
    switch (_step) {
      case 1:
        return PickServiceForm(
            workshopUid: widget.workshop.uid, onSave: handleSavePickedServices);
      case 2:
        return PickCarForm(appUserUid: appUserUid, onSave: handleSavePickedCar);
      case 3:
        return ConfirmOrderForm(
            appUserUid: appUserUid,
            car: _car,
            isLoading: _isLoading,
            order: _order,
            workshop: widget.workshop,
            onSave: () => handleSaveOrder(context, appUserUid, workshopUid));
      default:
        return PickServiceForm(
            workshopUid: widget.workshop.uid, onSave: handleSavePickedServices);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppUser? appUser = Provider.of<AppUser?>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Add order'),
          backgroundColor: Colors.amber,
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
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
              getOrderView(context, appUser!.uid, widget.workshop.uid)
            ]))));
  }
}
