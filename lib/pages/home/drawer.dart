import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/home/owner/workshop_form_page.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/pages/shared/slide_up_roles_panel_content.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class Pair<A, B> {
  final A role;
  final B availableNewRoles;

  const Pair(this.role, this.availableNewRoles);

  @override
  String toString() => '$role, $availableNewRoles';
}

class CustomDrawer extends StatelessWidget {
  final AppUser user;
  final void Function() handleOpenProfilePage;
  final void Function() handleSignOut;

  CustomDrawer(this.user, this.handleOpenProfilePage, this.handleSignOut);

  @override
  Widget build(BuildContext context) {
    String avatar = user.avatar ?? '';
    String drawerUserName = '${user.firstName!} ${user.lastName!}';

    return FutureBuilder<Pair<String, List<String>>>(
        future: getUserRoles(user.roles!),
        builder: (BuildContext context,
            AsyncSnapshot<Pair<String, List<String>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          } else {
            Pair<String, List<String>> pair = snapshot.data!;
            String role = pair.role;
            List<String> availableNewRoles = pair.availableNewRoles;

            String formattedRole =
                '${role[0].toUpperCase()}${role.substring(1).toLowerCase()}';

            Widget roleBasedTiles =
                buildRoleBasedTiles(context, availableNewRoles, user.roles!);

            return Drawer(
                child: ListView(children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: isAvatarDefined(avatar)
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(avatar),
                      )
                    : Icon(Icons.account_circle, size: 60.0),
                accountName: Text(
                  drawerUserName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                accountEmail: Text(
                  formattedRole,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              ListTile(
                title: Text('My profile'),
                leading: Icon(Icons.person_rounded),
                onTap: handleOpenProfilePage,
              ),
              ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings),
                onTap: handleSignOut,
              ),
              roleBasedTiles,
              ListTile(
                title: Text('Log out'),
                leading: Icon(Icons.logout),
                onTap: handleSignOut,
              ),
            ]));
          }
        });
  }
}

Future<Pair<String, List<String>>> getUserRoles(List<String> userRoles) async {
  String? prefsRole = await getPreferencesUserRole();
  String role = prefsRole != null && userRoles.contains(prefsRole)
      ? prefsRole
      : userRoles.first;

  List<String> availableNewRoles = ROLES.ROLES.where((r) {
    return !userRoles.contains(r);
  }).toList();

  return Pair<String, List<String>>(role, availableNewRoles);
}

buildRoleBasedTiles(BuildContext context, List<String> availableNewRoles,
    List<String> userRoles) {
  Widget createNewRoleTile = ListTile(
      title: Text('Create new user role profile'),
      leading: Icon(Icons.person_rounded),
      onTap: () =>
          openRoleBasedModal(context: context, roles: availableNewRoles));

  Widget changeRoleTile = ListTile(
      title: Text('Change current role profile'),
      leading: Icon(Icons.person_rounded),
      onTap: () => openRoleBasedModal(context: context, roles: userRoles));

  if (userRoles.length < 3) {
    if (availableNewRoles.length > 0) {
      return createNewRoleTile;
    } else {
      return [changeRoleTile, createNewRoleTile];
    }
  } else {
    return null;
  }
}

openRoleBasedModal(
    {required BuildContext context, required List<String> roles}) {
  void handleOpenWorkshopForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkshopFormPage(
                workshop: null,
              )),
    );
  }

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SlideUpRolesPanel(roles: roles, onSelect: handleOpenWorkshopForm);
    },
  );
}
