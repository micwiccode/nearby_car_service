import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'authentication/authentication.dart';
import 'home/home.dart';
import 'shared/loading_spinner.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return StreamBuilder<AppUser?>(
        stream: AuthService().user,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }
          return snapshot.data == null || appUser == null
              ? Authentication()
              : Home();
        });
  }
}
