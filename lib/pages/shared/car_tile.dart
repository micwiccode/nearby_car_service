import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/car.dart';

import 'loading_spinner.dart';

class CarTile extends StatelessWidget {
  final Car car;
  final Function? onTap;
  final bool? isEditable;

  const CarTile({
    required this.car,
    this.isEditable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isAvatarDefined(car.avatar)
          ? CachedNetworkImage(
              imageUrl: car.avatar,
              imageBuilder: (context, imageProvider) => Container(
                width: 40,
                height: 40,
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
          : Icon(Icons.directions_car, size: 40.0),
      trailing: (isEditable != null && isEditable!)
          ? Icon(Icons.more_horiz, size: 20.0)
          : null,
      title: Text(car.mark + ' ' + car.model, style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(car.productionYear.toString()),
      onTap: () => onTap != null && onTap!(car),
    );
  }
}
