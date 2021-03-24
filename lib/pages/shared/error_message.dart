import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String error;

  ErrorMessage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0));
  }
}
