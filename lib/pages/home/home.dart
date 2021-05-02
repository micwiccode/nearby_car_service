import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import 'onboarding_page.dart';
import 'main_menu_page.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    void handleSignOut() async {
      await _auth.signOut(context: context);
    }

    return StreamBuilder<AppUser>(
        stream: DatabaseService(uid: appUser!.uid).appUser,
        initialData: null,
        builder: (context, snapshot) {
          print(snapshot.data);
          print(snapshot.error);

          return Scaffold(
              appBar: AppBar(
                title: const Text('Nearby car service'),
                backgroundColor: Colors.amber,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: handleSignOut),
                ],
              ),
              body: !snapshot.hasData
                  ? LoadingSpinner()
                  : snapshot.data == null || snapshot.data!.onboardingStep! < 4
                      ? OnboardingPage(user: snapshot.data)
                      : MainMenuPage(user: snapshot.data!));
        });
  }
}
