import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/services_view.dart';
import 'package:nearby_car_service/pages/shared/workshop_view.dart';

import 'order/order_steps_page.dart';

class WorkshopClientPage extends StatefulWidget {
  final Workshop workshop;

  const WorkshopClientPage({required this.workshop, Key? key})
      : super(key: key);

  @override
  _WorkshopClientPageState createState() => _WorkshopClientPageState();
}

class _WorkshopClientPageState extends State<WorkshopClientPage> {
  @override
  Widget build(BuildContext context) {
    void openCreateOrderPage() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              OrderStepsPage(workshop: widget.workshop),
          fullscreenDialog: true,
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.workshop.name),
          backgroundColor: Colors.amber,
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  WorkshopView(
                    workshop: widget.workshop,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: Text('Services',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0))),
                  ServicesView(
                      workshop: widget.workshop,
                      onlyActive: true,
                      isEditable: false),
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: openCreateOrderPage,
          child: Icon(Icons.add_shopping_cart_rounded),
        ));
  }
}
