import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String? acceptLabel;
  final String? denyLabel;
  final Function? onAccept;
  final Function? onDeny;

  ConfirmDialog({
    required this.title,
    this.acceptLabel,
    this.denyLabel,
    this.onAccept,
    this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 14)),
        actions: onAccept != null && onDeny != null
            ? <Widget>[
                TextButton(
                  onPressed: () => onDeny!(),
                  child: Text(denyLabel ?? 'No'),
                ),
                TextButton(
                  onPressed: () => onAccept!(),
                  child: Text(acceptLabel ?? 'Yes'),
                )
              ]
            : <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ]);
  }
}
