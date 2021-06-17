import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/helpers/pick_image.dart';

import 'loading_spinner.dart';

class WorkshopAvatar extends StatelessWidget {
  final avatar;
  final Function onImageChange;

  WorkshopAvatar(this.avatar, this.onImageChange);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: () => pickImage(onImageChange),
            child: isAvatarDefined(avatar)
                ? _buildWorkshopAvatar()
                : _buildEmptyWorkshopAvatar()));
  }

  Widget _buildWorkshopAvatar() {
    return Stack(children: [
      (avatar.contains('/storage')
          ? Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: FileImage(
                      File(avatar),
                    ),
                  )))
          : CachedNetworkImage(
              imageUrl: avatar,
              imageBuilder: (context, imageProvider) => Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => LoadingSpinner(),
            )),
      Positioned(
        bottom: -20.0,
        right: -20.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              onPressed: () => onImageChange(null)),
        ),
      )
    ]);
  }

  Widget _buildEmptyWorkshopAvatar() {
    return Stack(children: [
      Icon(
        Icons.business_outlined,
        color: Colors.black,
        size: 75.0,
      ),
      Positioned(
        bottom: -5.0,
        right: -5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.add_circle,
            color: Colors.green,
          ),
        ),
      )
    ]);
  }
}
