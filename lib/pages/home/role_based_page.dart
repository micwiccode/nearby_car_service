import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

import 'client/main_menu_page.dart' as ClientMainMenuPage;
import 'owner/main_menu_page.dart' as OwnertMainMenuPage;

class RoleBasedPage extends StatefulWidget {
  final AppUser user;

  const RoleBasedPage({required this.user, Key? key}) : super(key: key);

  @override
  _RoleBasedPageState createState() => _RoleBasedPageState();
}

class _RoleBasedPageState extends State<RoleBasedPage> {
  String _currentRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  _loadUserRole() async {
    print(widget.user);
    List<String> appUserRoles = widget.user.roles!;
    String? prefsRole = await getPreferencesUserRole(widget.user.uid);
    String newRole = prefsRole != null && appUserRoles.contains(prefsRole)
        ? prefsRole
        : appUserRoles.first;

    setState(() {
      _currentRole = newRole;
    });
  }

  Widget _loadMenuBasedOnRole() {
    switch (_currentRole) {
      case ROLES.CLIENT:
        return ClientMainMenuPage.MainMenuPage(user: widget.user);
      case ROLES.OWNER:
        return OwnertMainMenuPage.MainMenuPage();
      // case ROLES.EMPLOYEE:
      //   return MainMenuPage(user: widget.user);
      default:
        return ClientMainMenuPage.MainMenuPage(user: widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loadMenuBasedOnRole();
  }
}
