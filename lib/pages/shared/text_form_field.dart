import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget? suffixIcon;
  final bool obscureText;
  final Function? functionValidate;
  final bool onlyDigits;
  final bool numberKeyboardType;
  final bool isLastFormInput;

  TextFormFieldWidget({
    required this.controller,
    required this.labelText,
    this.suffixIcon,
    this.obscureText = false,
    this.onlyDigits = false,
    this.functionValidate,
    this.numberKeyboardType = false,
    this.isLastFormInput = false,
  });

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return Container(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            obscureText: obscureText,
            validator: (value) {
              if (functionValidate != null) {
                return functionValidate!();
              }
              if (value != null && value.trim().isEmpty) {
                return 'Please enter ${labelText.toLowerCase()}';
              }
              return null;
            },
            inputFormatters: onlyDigits
                ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                : [],
            keyboardType: onlyDigits || numberKeyboardType
                ? TextInputType.number
                : TextInputType.text,
            controller: controller,
            onEditingComplete: () =>
                isLastFormInput ? node.unfocus() : node.nextFocus(),
            decoration: InputDecoration(
              labelText: labelText,
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
              suffixIcon: suffixIcon,
            ),
          )),
    );
  }
}
