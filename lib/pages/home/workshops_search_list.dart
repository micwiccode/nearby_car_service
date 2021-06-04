import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/workshop.dart';

class WorkshopsSearchList extends StatefulWidget {
  final List<Workshop> workshops;
  const WorkshopsSearchList({required this.workshops, Key? key})
      : super(key: key);

  @override
  _WorkshopsSearchListState createState() => _WorkshopsSearchListState();
}

class _WorkshopsSearchListState extends State<WorkshopsSearchList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.workshops.map((Workshop workshop) {
        String? avatar = workshop.avatar;
        return ListTile(
          leading: isAvatarDefined(avatar)
              ? CircleAvatar(
                  backgroundImage: NetworkImage(avatar!),
                )
              : Icon(Icons.home, size: 40.0),
          title: Text(workshop.name),
          subtitle: Text(workshop.address!.getAddressDetails()),
        );
      }).toList(),
    );
  }
}
