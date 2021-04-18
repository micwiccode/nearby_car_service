import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String labelText;
  final Widget? suffixIcon;
  final bool obscureText;
  final Function? functionValidate;
  final bool onlyDigits;
  final void Function(String)? onChanged;

  TextFormFieldWidget({
    required this.labelText,
    required this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.onlyDigits = false,
    this.functionValidate,
  });

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      validator: (value) {
        if (widget.functionValidate != null) {
          return widget.functionValidate!(value);
        }
        return null;
      },
      keyboardType:
          widget.onlyDigits ? TextInputType.number : TextInputType.text,
      inputFormatters: widget.onlyDigits
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : [],
      decoration: InputDecoration(
        labelText: widget.labelText,
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
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
