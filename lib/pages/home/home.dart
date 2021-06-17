import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/user_service.dart';
import 'package:provider/provider.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import 'drawer.dart';
import 'onboarding/onboarding_page.dart';
import 'profile_page.dart';
import 'role_based_page.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    void handleSignOut() async {
      await _auth.signOut(context: context);
    }

    return StreamBuilder<AppUser>(
        stream: AppUserDatabaseService(uid: appUser!.uid).appUser,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          AppUser? user = snapshot.data;

          if (user == null || user.onboardingStep! < 4) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Nearby car service'),
                  backgroundColor: Colors.amber,
                  elevation: 0.0,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      onPressed: handleSignOut,
                    )
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                body: OnboardingPage(user: user));
          }

          void handleOpenProfilePage() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
            );
          }

          return Scaffold(
              key: _scaffoldState,
              endDrawer:
                  CustomDrawer(user, handleOpenProfilePage, handleSignOut),
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
                      onPressed: () =>
                          _scaffoldState.currentState!.openEndDrawer()),
                ],
              ),
              body: RoleBasedPage(user: user));
        });
  }
}
