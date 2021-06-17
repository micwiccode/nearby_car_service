import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:nearby_car_service/models/app_transaction.dart';
import 'package:nearby_car_service/models/order.dart';
import 'package:nearby_car_service/pages/shared/service_tile.dart';
import 'package:nearby_car_service/utils/orders_service.dart';
import 'package:nearby_car_service/utils/transactions_service.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;

class TransactionPage extends StatefulWidget {
  final Order order;

  const TransactionPage({required this.order, Key? key}) : super(key: key);

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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
    bool _googlePayEnabled = false;

    void _cardEntryCancel() async {
      final _snackBar = SnackBar(content: Text('Invalid card'));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }

    void _onCardEntryComplete() async {
      final _snackBar =
          SnackBar(content: Text('Payment finished successfully'));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }

    Future<void> chargeCard(CardDetails result) async {
      String? chargeHost = dotenv.env['CHARGE_HOST'];

      if (chargeHost == null) {
        throw ('No charge host provided');
      }

      Uri chargeUrl = Uri.parse("$chargeHost/chargeForCookie");

      var body = jsonEncode({"nonce": result.nonce});
      http.Response response;
      try {
        response = await http.post(chargeUrl, body: body, headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        });
      } on SocketException catch (ex) {
        throw ChargeException(ex.message);
      }

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return;
      } else {
        throw ChargeException(responseBody["errorMessage"]);
      }
    }

    void _cardNonceRequestSuccess(CardDetails result) async {
      try {
        // take payment with the card nonce details
        // you can take a charge
        await chargeCard(result);

        await OrdersDatabaseService()
            .updateOrderStatus(widget.order.uid, null, STATUSES.PAID);

        String workshopUid = widget.order.workshopUid;

        AppTransaction transaction = AppTransaction(
            orderUid: widget.order.uid,
            workshopUid: workshopUid,
            price: widget.order.price);

        await AppTransactionsDatabaseService(workshopUid: workshopUid)
            .createAppTransaction(transaction);

        Navigator.of(context).pop();

        // payment finished successfully
        // you must call this method to close card entry
        // this ONLY apply to startCardEntryFlow, please don't call this method when use startCardEntryFlowWithBuyerVerification
        InAppPayments.completeCardEntry(
            onCardEntryComplete: _onCardEntryComplete);
      } on Exception catch (ex) {
        // payment failed to complete due to error
        // notify card entry to show processing error
        InAppPayments.showCardNonceProcessingError(ex.toString());
        final _snackBar = SnackBar(content: Text(ex.toString()));
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }

    Future<void> _initSquarePayment() async {
      await dotenv.load(fileName: ".env");

      String? paymentID = dotenv.env['PAYMENT_API_KEY'];
      String? paymentLocationID = dotenv.env['PAYMENT_LOCATION_ID'];

      if (paymentID == null) {
        throw ('No payment ID provided');
      }

      if (paymentLocationID == null) {
        throw ('No payment location ID provided');
      }

      await InAppPayments.setSquareApplicationId(paymentID);

      var canUseGooglePay = false;
      if (Platform.isAndroid) {
        // initialize the google pay with square location id
        // use test environment first to quick start
        await InAppPayments.initializeGooglePay(
            'LOCATION_ID', google_pay_constants.environmentTest);
        // always check if google pay supported on that device
        // before enable google pay
        canUseGooglePay = await InAppPayments.canUseGooglePay;
      }
      setState(() {
        _googlePayEnabled = canUseGooglePay;
      });
    }

    void handlePay() async {
      await _initSquarePayment();

      await InAppPayments.startCardEntryFlow(
          onCardNonceRequestSuccess: _cardNonceRequestSuccess,
          onCardEntryCancel: _cardEntryCancel);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Pay for order'),
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
              ...widget.order.services
                  .map((service) => ServiceTile(service: service)),
              _buildText(
                  'Total order price: ${formatPrice(widget.order.price)}')
            ]))),
        floatingActionButton: FloatingActionButton(
          onPressed: handlePay,
          child: Icon(Icons.payment),
        ));
  }
}

class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}
