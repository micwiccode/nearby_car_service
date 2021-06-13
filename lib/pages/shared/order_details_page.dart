import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/formatPrice.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/pages/shared/service_tile.dart';
import 'package:nearby_car_service/utils/convert_date_time.dart';
import 'package:nearby_car_service/utils/orders_service.dart';

import 'button.dart';
import 'loading_spinner.dart';
import 'price_input.dart';
import 'text_form_field.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderUid;
  final String? employeeUid;

  const OrderDetailsPage({required this.orderUid, this.employeeUid, Key? key})
      : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int _currentStep = 0;
  bool _isLoading = false;

  final GlobalKey<FormState> _changePriceFormKey = GlobalKey<FormState>();
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

  void handleAddMessage() async {
    if (_inputController.text.trim().length > 0) {
      setState(() => _isLoading = true);

      if (widget.employeeUid == null) {
        await OrdersDatabaseService()
            .addOrderQuestion(widget.orderUid, _inputController.text);
      } else {
        await OrdersDatabaseService().addOrderInfo(
            widget.orderUid, widget.employeeUid!, _inputController.text);
      }

      _inputController.text = '';

      setState(() => _isLoading = false);
    }
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
    return event['type'];
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

          return Scaffold(
            appBar: AppBar(
              title: Text(
                  widget.employeeUid == null ? 'Your order' : 'Order details'),
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
                  _buildLabel('Services'),
                  ...order.services
                      .map((service) => ServiceTile(service: service)),
                  _buildText('Total min price: ${formatPrice(order.price)}'),
                  _buildLabel('History'),
                  Stepper(
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
                  _isLoading
                      ? LoadingSpinner()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                          child: Container(
                            child: Column(children: [
                              TextFormField(
                                controller: _inputController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.only(left: 25.0),
                                    hintText: widget.employeeUid == null
                                        ? 'Leave a question'
                                        : 'Leave an info',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0))),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Button(
                                  onPressed: handleAddMessage,
                                  text: 'Send',
                                ),
                              ),
                              if (widget.employeeUid != null)
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Button(
                                    onPressed: () => handleChangePrice(context),
                                    text: 'Change price',
                                  ),
                                )
                            ]),
                          ))
                ],
              )),
            ),
          );
        });
  }
}
