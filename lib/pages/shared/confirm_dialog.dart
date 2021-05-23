import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final onAccept;
  final onDeny;

  ConfirmDialog({
    required this.title,
    required this.onDeny,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text(title), actions: <Widget>[
      TextButton(
        onPressed: onDeny,
        child: Text('No'),
      ),
      TextButton(
        onPressed: onAccept,
        child: Text('Yes'),
      )
    ]);
  }
}
