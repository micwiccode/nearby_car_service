import 'dart:math';

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/home/client/transaction_page.dart';
import 'package:nearby_car_service/pages/shared/service_tile.dart';
import 'package:nearby_car_service/utils/convert_date_time.dart';
import 'package:nearby_car_service/utils/orders_service.dart';
import 'package:nearby_car_service/utils/user_service.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';

import 'button.dart';
import 'car_tile.dart';
import 'loading_spinner.dart';
import 'price_input.dart';
import 'text_form_field.dart';

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;
import 'package:nearby_car_service/consts/order_events_types.dart' as EVENTS;

import 'workshop_tile.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderUid;
  final Car car;
  final String? employeeUid;

  const OrderDetailsPage(
      {required this.orderUid, required this.car, this.employeeUid, Key? key})
      : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int _currentStep = 0;

  final GlobalKey<FormState> _changePriceFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addMessageFormKey = GlobalKey<FormState>();
  final TextEditingController _inputController = new TextEditingController();
  final TextEditingController _orderChangeReasonController =
      TextEditingController(text: '');
  final MoneyMaskedTextController _orderPriceController =
      MoneyMaskedTextController(initialValue: 0.0, rightSymbol: ' \€');

  toStep(int step) {
    setState(() => _currentStep = step);
  }

  goNext() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  goPrevious() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  void openTransactionPage(BuildContext context, Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionPage(order: order)),
    );
  }

  void handleAddMessage(BuildContext context) async {
    void addMessage() async {
      if (_addMessageFormKey.currentState!.validate()) {
        if (widget.employeeUid == null) {
          await OrdersDatabaseService()
              .addOrderQuestion(widget.orderUid, _inputController.text);
        } else {
          await OrdersDatabaseService().addOrderInfo(
              widget.orderUid, widget.employeeUid!, _inputController.text);
        }
        Navigator.pop(context);
      }
    }

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Form(
                  key: _addMessageFormKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                      child: TextFormField(
                        controller: _inputController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 25.0),
                            hintText: widget.employeeUid == null
                                ? 'Leave a question'
                                : 'Leave an info',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0))),
                      ),
                    ),
                    Button(
                      onPressed: addMessage,
                      text: 'Send',
                    ),
                  ])),
            ));
  }

  void handleChangePrice(BuildContext context) async {
    void savePriceChange() async {
      if (_changePriceFormKey.currentState!.validate()) {
        await OrdersDatabaseService().changeOrderPrice(
            widget.orderUid,
            widget.employeeUid!,
            _orderChangeReasonController.text,
            (_orderPriceController.numberValue * 100).toInt());

        Navigator.pop(context);
      }
    }

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Form(
                  key: _changePriceFormKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    PriceInput(
                        controller: _orderPriceController,
                        label: 'Order price'),
                    TextFormFieldWidget(
                      controller: _orderChangeReasonController,
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      labelText: 'Change reason',
                    ),
                    Button(
                      onPressed: savePriceChange,
                      text: 'Save',
                    ),
                  ])),
            ));
  }

  String getStepTitle(Map<String, dynamic> event) {
    switch (event['type']) {
      case EVENTS.CREATE:
        {
          return 'Order created';
        }

      case EVENTS.ACCEPT:
        {
          return 'Order accepted by employee';
        }

      case EVENTS.PROGRESS:
        {
          return 'Order marked as in progress';
        }

      case EVENTS.DONE:
        {
          return 'Order finished';
        }

      case EVENTS.PAID:
        {
          return 'Order paid';
        }

      case EVENTS.CHANGE_PRICE:
        {
          return 'Emloyee has changed price';
        }
      case EVENTS.EMPLOYEE_INFO:
        {
          return 'Emloyee has left a message';
        }

      case EVENTS.CLIENT_QUESTION:
        {
          return 'Client has asked a question';
        }

      default:
        {
          return 'Order created';
        }
    }
  }

  List<Step> _getOrderSteps(Order order) {
    return order.events
        .map((e) => Step(
              title: Text(getStepTitle(e)),
              subtitle: Text(convertDateTime(e['date'])),
              content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    e['content'] != null ? Text(e['content']) : Container()
                  ]),
              isActive: _currentStep >= 0,
            ))
        .toList();
  }

  Widget _buildLabel(String text) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)));
  }

  Widget _buildText(String text) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10), child: Text(text));
  }

  String getNextStatus(String status) {
    switch (status) {
      case STATUSES.NEW:
        {
          return STATUSES.ACCEPTED;
        }

      case STATUSES.ACCEPTED:
        {
          return STATUSES.IN_PROGRESS;
        }

      case STATUSES.IN_PROGRESS:
        {
          return STATUSES.DONE;
        }

      default:
        {
          return STATUSES.ACCEPTED;
        }
    }
  }

  void handleChangeStatus(String orderUid, String status) async {
    String nextStatus = getNextStatus(status);
    await OrdersDatabaseService()
        .updateOrderStatus(orderUid, widget.employeeUid, nextStatus);
  }

  String getChangeStatusLabel(String status) {
    switch (status) {
      case STATUSES.NEW:
        {
          return 'Accept order';
        }

      case STATUSES.ACCEPTED:
        {
          return 'Start order progress';
        }

      case STATUSES.IN_PROGRESS:
        {
          return 'Mark order as done';
        }

      default:
        {
          return 'Accept order';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Order>(
        stream: OrdersDatabaseService(orderUid: widget.orderUid).order,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          Order order = snapshot.data!;

          if (widget.employeeUid == null) {
            return StreamBuilder<Workshop>(
                stream: WorkshopDatabaseService(workshopUid: order.workshopUid)
                    .employeeWorkshop,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingSpinner();
                  }

                  Workshop workshop = snapshot.data!;

                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Your order'),
                      backgroundColor: Colors.amber,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      )),
                    ),
                    body: Container(
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Workshop'),
                          WorkshopTile(workshop: workshop),
                          _buildLabel('Services'),
                          ...order.services
                              .map((service) => ServiceTile(service: service)),
                          _buildLabel('Car'),
                          CarTile(car: widget.car),
                          _buildText(
                              'Total price: ${formatPrice(order.price)}'),
                          _buildLabel('History'),
                          Stepper(
                            key: Key(Random.secure().nextDouble().toString()),
                            type: StepperType.vertical,
                            physics: ScrollPhysics(),
                            currentStep: _currentStep,
                            steps: _getOrderSteps(order),
                            onStepTapped: (step) => toStep(step),
                            controlsBuilder: (BuildContext context,
                                {VoidCallback? onStepContinue,
                                VoidCallback? onStepCancel}) {
                              return Container();
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                              child: Container(
                                child: Column(children: [
                                  if (order.status == STATUSES.DONE)
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Button(
                                        onPressed: () =>
                                            openTransactionPage(context, order),
                                        text: 'Pay for order',
                                      ),
                                    ),
                                  if (order.status != STATUSES.PAID)
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Button(
                                          onPressed: () =>
                                              handleAddMessage(context),
                                          text: 'Leave a question'),
                                    ),
                                ]),
                              ))
                        ],
                      )),
                    ),
                  );
                });
          } else {
            return StreamBuilder<AppUser>(
                stream: AppUserDatabaseService(uid: order.appUserUid).appUser,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingSpinner();
                  }

                  AppUser user = snapshot.data!;

                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Order details'),
                      backgroundColor: Colors.amber,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      )),
                    ),
                    body: Container(
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Client'),
                          _buildText('${user.firstName} ${user.lastName}'),
                          _buildText('${user.email}, ${user.phoneNumber}'),
                          _buildLabel('Services'),
                          ...order.services
                              .map((service) => ServiceTile(service: service)),
                          _buildLabel('Car'),
                          CarTile(car: widget.car),
                          _buildText(
                              'Total price: ${formatPrice(order.price)}'),
                          _buildLabel('History'),
                          Stepper(
                            key: Key(Random.secure().nextDouble().toString()),
                            type: StepperType.vertical,
                            physics: ScrollPhysics(),
                            currentStep: _currentStep,
                            steps: _getOrderSteps(order),
                            onStepTapped: (step) => toStep(step),
                            controlsBuilder: (BuildContext context,
                                {VoidCallback? onStepContinue,
                                VoidCallback? onStepCancel}) {
                              return Container();
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                              child: Container(
                                child: Column(children: [
                                  if (order.status != STATUSES.PAID)
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Button(
                                        onPressed: () =>
                                            handleAddMessage(context),
                                        text: 'Leave an info',
                                      ),
                                    ),
                                  if (order.status != STATUSES.DONE &&
                                      order.status != STATUSES.PAID)
                                    Column(children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Button(
                                          onPressed: () => handleChangeStatus(
                                              order.uid, order.status),
                                          text: getChangeStatusLabel(
                                              order.status),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Button(
                                          onPressed: () =>
                                              handleChangePrice(context),
                                          text: 'Change price',
                                        ),
                                      ),
                                    ])
                                ]),
                              ))
                        ],
                      )),
                    ),
                  );
                });
          }
        });
  }
}
