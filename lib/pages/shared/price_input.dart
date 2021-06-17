import 'package:flutter/material.dart';
import 'package:extended_masked_text/extended_masked_text.dart';

class PriceInput extends StatelessWidget {
  final MoneyMaskedTextController controller;
  final String label;
  final Function? functionValidate;

  PriceInput(
      {required this.controller, required this.label, this.functionValidate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (functionValidate != null) {
            return functionValidate!();
          }
          if (value != null && value.trim().isEmpty) {
            return 'Please enter price';
          }
          //  if (value < 0) {
          //   return 'Please enter price';
          // }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.8,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
