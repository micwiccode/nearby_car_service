import 'package:flutter/material.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import 'onboarding_page.dart';
import 'main_menu_page.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    handleSignOut() async {
      await _auth.signOut(context: context);
    }

    bool isOnboardingCompleted() {
      return true;
    }

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
                icon: Icon(Icons.account_circle), onPressed: handleSignOut),
          ],
        ),
        body: isOnboardingCompleted() ? MainMenuPage() : OnboardingPage());
  }
}
