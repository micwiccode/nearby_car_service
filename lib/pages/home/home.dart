import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import 'drawer.dart';
import 'onboarding_page.dart';
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
        stream: DatabaseService(uid: appUser!.uid).appUser,
        initialData: null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          if (snapshot.data == null || snapshot.data!.onboardingStep! < 4) {
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
                ),
                body: OnboardingPage(user: snapshot.data));
          }

          AppUser user = snapshot.data!;

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
