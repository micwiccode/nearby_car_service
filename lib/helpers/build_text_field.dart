import 'package:flutter/material.dart';

Widget buildTextField(String text, controller) {
  return Padding(
    padding: EdgeInsets.all(10.0),
    child: TextFormField(
      controller: controller,
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $text';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: text,
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
