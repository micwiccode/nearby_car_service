import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/workshop.dart';

import 'loading_spinner.dart';

class WorkshopTile extends StatelessWidget {
  final Workshop workshop;
  final Function? onTap;

  const WorkshopTile({required this.workshop, this.onTap});

  @override
  Widget build(BuildContext context) {
    Address address = workshop.address!;

    return ListTile(
        title: Text(workshop.name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
            )),
        subtitle: Text(address.getAddressDetails()),
        leading:
            (workshop.avatar != null && workshop.avatar!.contains('/storage'))
                ? CachedNetworkImage(
                    imageUrl: workshop.avatar!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => LoadingSpinner(),
                  )
                : Icon(
                    Icons.business_center_outlined,
                    color: Colors.black,
                    size: 25.0,
                  ),
        onTap: () => onTap != null && onTap!(workshop));
  }
}
