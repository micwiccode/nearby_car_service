import 'package:flutter/material.dart';

class WorkshopAvatar extends StatelessWidget {
  final String? avatar;
  final double? size;

  WorkshopAvatar({this.avatar, this.size});

  @override
  Widget build(BuildContext context) {
    return avatar != null
        ? Image.network(
            avatar!,
            height: size,
          )
        : Icon(
            Icons.business_center_outlined,
            color: Colors.black,
            size: 35.0,
          );
  }
}
