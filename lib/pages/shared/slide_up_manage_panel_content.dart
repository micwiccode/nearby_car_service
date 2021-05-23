import 'package:flutter/material.dart';

class SlideUpManagePanel extends StatelessWidget {
  final String editText;
  final String removeText;
  final handleEdit;
  final handleRemove;

  SlideUpManagePanel(
      {required this.editText,
      required this.removeText,
      required this.handleEdit,
      required this.handleRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: ListView(children: [
        ListTile(
          leading: Icon(Icons.edit, size: 30.0),
          title: Text(editText),
          onTap: handleEdit,
        ),
        ListTile(
          leading: Icon(Icons.delete_forever, size: 30.0),
          title: Text(removeText),
          onTap: handleRemove,
        )
      ]),
    );
  }
}
