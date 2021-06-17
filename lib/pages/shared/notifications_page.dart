import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/notification.dart';
import 'package:nearby_car_service/utils/notifications_service.dart';
import 'package:provider/provider.dart';

import 'loading_spinner.dart';
import 'notification_tile.dart';

class AppNotificationsPage extends StatelessWidget {
  const AppNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    if (appUser == null) {
      return Text('No appUser provided');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          backgroundColor: Colors.amber,
        ),
        body: StreamBuilder<List<AppNotification>>(
          stream: AppNotificationsService(receiverUserUid: appUser.uid)
              .userNotifications,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingSpinner();
            }

            if (snapshot.data == null) {
              return Text('AppNotifications snapshot error');
            }

            List<AppNotification> notifications = snapshot.data!;

            return notifications.length < 1
                ? Center(child: Text('No notifications'))
                : ListView(
                    children: notifications
                        .map((AppNotification notification) =>
                            AppNotificationTile(notification: notification))
                        .toList());
          },
        ));
  }
}
