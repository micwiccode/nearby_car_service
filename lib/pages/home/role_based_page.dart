import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'client/main_menu_page.dart' as ClientMainMenuPage;
import 'owner/main_menu_page.dart' as OwnertMainMenuPage;
import 'employee/main_menu_page.dart' as EmployeeMainMenuPage;

class RoleBasedPage extends StatefulWidget {
  final AppUser user;

  const RoleBasedPage({required this.user, Key? key}) : super(key: key);

  @override
  _RoleBasedPageState createState() => _RoleBasedPageState();
}

class _RoleBasedPageState extends State<RoleBasedPage> {
  Widget _loadMenuBasedOnRole(String role) {
    switch (role) {
      case ROLES.CLIENT:
        return ClientMainMenuPage.MainMenuPage(user: widget.user);
      case ROLES.OWNER:
        return OwnertMainMenuPage.MainMenuPage();
      case ROLES.EMPLOYEE:
        return EmployeeMainMenuPage.MainMenuPage(user: widget.user);
      default:
        return ClientMainMenuPage.MainMenuPage(user: widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StreamingSharedPreferences>(
        future: StreamingSharedPreferences.instance,
        builder: (BuildContext context,
            AsyncSnapshot<StreamingSharedPreferences> prefsSnapshot) {
          if (!prefsSnapshot.hasData) {
            return LoadingSpinner();
          }

          return PreferenceBuilder<String>(
              preference: getSteamPreferencesUserRole(
                  prefsSnapshot.data!, widget.user.uid),
              builder: (BuildContext context, String role) {
                return _loadMenuBasedOnRole(role);
              });
        });
  }
}
