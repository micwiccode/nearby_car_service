import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_avatar_defined.dart';

class CustomDrawer extends StatelessWidget {
  final String? avatar;
  final String drawerUserName;
  final String formattedRole;
  final void Function() handleOpenProfilePage;
  final void Function() handleSignOut;

  CustomDrawer(this.avatar, this.drawerUserName, this.formattedRole,
      this.handleOpenProfilePage, this.handleSignOut);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
        currentAccountPicture: isAvatarDefined(avatar)
            ? CircleAvatar(
                backgroundImage: NetworkImage(avatar as String),
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
      ListTile(
        title: Text('Log out'),
        leading: Icon(Icons.logout),
        onTap: handleSignOut,
      ),
    ]));
  }
}
