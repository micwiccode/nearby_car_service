import 'package:flutter/material.dart';

import 'loading_spinner.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String text;
  final bool isLoading;

  Button({required this.onPressed, required this.text, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        primary: Colors.amber[600],
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      child: isLoading
          ? LoadingSpinner(isButtonLoading: true)
          : Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
    );
  }
}
