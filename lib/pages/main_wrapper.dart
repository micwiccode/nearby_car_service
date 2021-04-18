import 'package:firebase_auth/firebase_auth.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'authentication/authentication.dart';
import 'home/home.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    // return Home();
    return appUser == null ? Authentication() : Home();
  }
}
