import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/pages/shared/slide_up_roles_panel_content.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;
import 'package:nearby_car_service/utils/database.dart';

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
        future: getUserRoles(user.roles!, user.uid),
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

            List<Widget> roleBasedTiles = buildRoleBasedTiles(
                context: context,
                availableNewRoles: availableNewRoles,
                userRoles: user.roles!,
                userUid: user.uid,
                currentRole: role);

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
              ...roleBasedTiles,
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

Future<Pair<String, List<String>>> getUserRoles(
    List<String> userRoles, String userUid) async {
  String? prefsRole = await getPreferencesUserRole(userUid);
  String role = prefsRole != null && userRoles.contains(prefsRole)
      ? prefsRole
      : userRoles.first;

  List<String> availableNewRoles = ROLES.ROLES.where((r) {
    return !userRoles.contains(r);
  }).toList();

  return Pair<String, List<String>>(role, availableNewRoles);
}

buildRoleBasedTiles(
    {required BuildContext context,
    required List<String> availableNewRoles,
    required List<String> userRoles,
    required String userUid,
    String? currentRole}) {
  Widget createNewRoleTile = ListTile(
      title: Text('Create new user role profile'),
      leading: Icon(Icons.person_rounded),
      onTap: () => openRoleBasedModal(
          context: context,
          roles: availableNewRoles,
          onSelect: (selectedRole) async {
            await DatabaseService(uid: userUid).addAppUserRole(selectedRole);
            await setPreferencesUserRole(selectedRole, userUid);
          }));

  Widget changeRoleTile = ListTile(
      title: Text('Change current role profile'),
      leading: Icon(Icons.person_rounded),
      onTap: () => openRoleBasedModal(
          context: context,
          roles: userRoles,
          currentRole: currentRole,
          onSelect: (selectedRole) {
            setPreferencesUserRole(selectedRole, userUid);
          }));

  if (userRoles.length < 3) {
    if (availableNewRoles.length < 0) {
      return [changeRoleTile];
    } else {
      return [changeRoleTile, createNewRoleTile];
    }
  } else {
    return null;
  }
}

openRoleBasedModal(
    {required BuildContext context,
    required List<String> roles,
    required Function onSelect,
    String? currentRole}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Wrap(children: <Widget>[
        SlideUpRolesPanel(
            roles: roles, currentRole: currentRole, onSelect: onSelect)
      ]);
    },
  );
}
