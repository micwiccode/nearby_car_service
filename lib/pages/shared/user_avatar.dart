import 'package:flutter/material.dart';

class UsereAvatar extends StatelessWidget {
  final avatar;

  UsereAvatar(this.avatar);

  @override
  Widget build(BuildContext context) {
    return avatar
        ? Image(
            image: AssetImage(avatar),
            height: 20.0,
          )
        : Icon(
            Icons.time_to_leave_outlined ,
            color: Colors.black,
            size: 30.0,
          );
  }
}
