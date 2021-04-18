import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final avatar;

  Avatar({required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(15.0),
              width: 55.0,
              height: 55.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              child: avatar,
            )));
  }
}
