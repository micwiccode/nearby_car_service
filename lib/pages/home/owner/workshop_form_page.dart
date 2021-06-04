import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/commonForms/workshop_form.dart';

class WorkshopFormPage extends StatelessWidget {
  final Workshop? workshop;

  WorkshopFormPage({required this.workshop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(workshop == null ? 'Add new workshop' : 'Edit workshop'),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.amber,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          )),
      body: Center(
          child: WorkshopForm(
              workshop: workshop,
              onSubmitSuccess: () => Navigator.of(context).pop())),
    );
  }
}
