import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String text;

  Button({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.amber[600],
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
